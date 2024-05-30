#!/bin/bash

source /app/.process.env

function afficher_aide {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help           Obtenir de l'aide sur les commandes"
    echo "  --dev                Utilisation du BO dev"
}

function check {
    EXITCODE=$?
    if [ "$EXITCODE" -ne "0" ]; then
        destination_url='https://'$PROD_DOMAINE$PROD_URI_ERRORMONITORING
        host=$PROD_DOMAINE
        token=$PROD_TOKEN_ERRORMONITORING
        if [[ "$1" == true ]]; then
            destination_url='https://'$DEV_IP$DEV_URI_ERRORMONITORING
            host=$DEV_DOMAINE
            token=$DEV_TOKEN_ERRORMONITORING
        fi

        body="{\"task\": \"$2'_npm'\", \"action\": \"$3\", \"error_log\": \"$EXITCODE\"}"

        #Appel curl à l'API errorMonitoring
        curl -vvv -X POST -H "Authorization: Bearer "$token -H 'Content-Type: application/json' -H "Host: $host" -d "$body" --insecure $destination_url

        exit $EXITCODE
    fi
}

# Fonction pour extraire la version npm spécifiée dans le package.json
function get_npm_major_version() {
    local package_json="package.json"
    local npm_version=$(sed -n 's/.*"npm": "\([0-9]\+\).*/\1/p' "$package_json")
    echo "$npm_version"
}

# Fonction pour fusionner trois chaînes JSON en un seul tableau JSON
function merge_json_strings() {
    # Vérifier si le nombre d'arguments est correct
    if [ $# -ne 3 ]; then
        echo "Usage: merge_json_strings <json_string1> <json_string2> <json_string3>"
        return 1
    fi
    
    # Concaténer les chaînes JSON avec une virgule entre elles
    local merged_json="[{${1:1:-1},${2:1:-1},${3:1:-1}}]"

    # Retourner le JSON fusionné
    echo "$merged_json"
}

# Fonction pour extraire les parties de la version
function extract_version_parts() {
    local version="$1"
    echo "$version" | tr '.' ' ' 
}

# Fonction pour comparer les versions et déterminer le type de mise à jour
function compare_versions() {
    local current_version="$1"
    local new_version="$2"

    local current_parts=($(extract_version_parts "$current_version"))
    local new_parts=($(extract_version_parts "$new_version"))

    # Déterminer le nombre de parties dans les versions
    local num_parts_current=${#current_parts[@]}
    local num_parts_new=${#new_parts[@]}
    
    # Comparaison pour déterminer le type de mise à jour
    if [ "$num_parts_current" -eq "$num_parts_new" ]; then
        local i
        local update_type=""
        for ((i=0; i<$num_parts_current; i++)); do
            if [ "${current_parts[$i]}" -lt "${new_parts[$i]}" ]; then
                case "$i" in
                    $(($num_parts_current-1)))
                        update_type="patch" ;;
                    $(($num_parts_current-2)))
                        update_type="minor" ;;
                    $(($num_parts_current-3)))
                        update_type="major" ;;
                    *)
                        update_type="unknown" ;;
                esac
                break
            elif [ "${current_parts[$i]}" -gt "${new_parts[$i]}" ]; then
                update_type="unknown"
                break
            fi
        done
        echo "$update_type"
    else
        echo "diff_parts"
    fi
}

function format_before_send() {
    # Initialisation de la chaîne JSON
    json_string="{\"environnement\": \"$environment\", \"modules\": ["
    # Utiliser jq pour parcourir chaque élément du tableau et extraire les informations
    first=true
    # Utiliser jq pour parcourir chaque élément du tableau et extraire les informations
    for package_info in $(echo $merged_json | jq -c '.[] | to_entries[]'); do
        name=$(echo $package_info | jq -r '.key')
        homepage=$(echo $package_info | jq -r '.value.homepage')

        current=$(echo $package_info | jq -r '.value.current')
        # Si current est null, le remplacer par "0.0.0" (souvent pour les modules globaux)
        if [ "$current" == "null" ]; then
            current="0.0.0"
        fi
        wanted=$(echo $package_info | jq -r '.value.wanted')
        latest=$(echo $package_info | jq -r '.value.latest')

        update_type=$(compare_versions "$current" "$wanted")

        # Si la version souhaitée est égale à la version actuelle, utiliser latest_update_type,
        # sinon conserver update_type
        if [ "$update_type" != "unknown" ]; then
            severity=$(compare_versions "$current" "$latest")
            if [ "$update_type" == "$latest_update_type" ]; then
                update_type="$latest_update_type"
            fi
        fi

        # Construire l'objet JSON pour chaque paquet
        package_json=$(jq -n --arg name "$name" --arg current "$current" --arg wanted "$wanted" --arg latest "$latest" --arg severity "$severity" --arg homepage "$homepage" '{name: $name, current: $current, wanted: $wanted, latest: $latest, severity: $severity, homepage: $homepage}')

        # Ajouter une virgule si ce n'est pas le premier objet
        if [ "$first" = false ]; then
            json_string="$json_string,"
        fi
        # Ajouter l'objet JSON au json_string
        json_string="$json_string$package_json"

        # Mettre à jour le flag first
        first=false
    done
    # Fermer le tableau JSON
    json_string="$json_string]}"

    # Imprimer le json_string
    echo "$json_string"
}

function recup_module { 
    destination_url='https://'$PROD_DOMAINE$PROD_URI_VERSIONING
    host=$PROD_DOMAINE
    token=$PROD_TOKEN_VERSIONING
    if [[ "$1" == true ]]; then
        destination_url='https://'$DEV_IP$DEV_URI_VERSIONING
        host=$DEV_DOMAINE
        token=$DEV_TOKEN_VERSIONING
    fi

    # Se placer dans le répertoire /app
    cd /app
    check "$1" $CONTAINER_NAME $environment'_cd_app'
    echo "[Changement Dossier] : OK"

    # Définir l'environnement
    environment=$(grep -o '"name": *"[^"]*"' package.json | awk -F'"' '{print $4}')
    check "$1" $CONTAINER_NAME 'npm_show_name'
    echo "  [Récuppération Nom du Projet] : OK"

    # Récupérer la version majeure de npm spécifiée dans package.json
    npm_major_version=$(get_npm_major_version)

    if [ -n "$npm_major_version" ]; then
        echo "Version majeure de npm spécifiée dans package.json : $npm_major_version"
        echo "Installation de la dernière version de npm dans la branche $npm_major_version.x"
        npm install -g "npm@$npm_major_version"
    else
        echo "Aucune version majeure de npm spécifiée dans package.json. Installation de la dernière version de npm."
        npm install -g npm@latest
    fi

    # Récuppérer les modules globaux
    module_globale=$(npm outdated -l -g -json)
    module_globale=$(echo "$module_globale" | sed -e '/"dependent":/d' -e '/"type":/d' -e '/"location":/d')
    echo "  [Récuppération Modules Globaux] : OK"
    
    # Récuppérer les modules dev
    module_dev=$(npm outdated -l -json)
    module_dev=$(echo "$module_dev" | sed -e '/"dependent":/d' -e '/"type":/d' -e '/"location":/d')
    echo "  [Récuppération Modules] : OK"

    # Installation pour récuppérer les modules 
    install=$(npm ci)
    echo "  [Installation Modules] : OK"

    # Récuppérer les modules
    module=$(npm outdated -l -json)
    module=$(echo "$module" | sed -e '/"dependent":/d' -e '/"type":/d' -e '/"location":/d')
    echo "  [Récuppération Modules] : OK"

    # Fusionner les objets JSON
    merged_json=$(merge_json_strings "$module_globale" "$module_dev" "$module")
    echo "[Merge Modules] : OK"

    formatted_data=$(format_before_send "$merged_json" "$environment")
    echo "[Format Datas] : OK"
    
    # Envoyer la sortie via une requête curl (remplacez URL_DE_DESTINATION par l'URL de destination)
    curl -vvv -X POST -H "Authorization: Bearer "$token -H 'Content-Type: application/json' -H "Host: $host" -d "$formatted_data" --insecure $destination_url 
    check "$1" $CONTAINER_NAME 'curl'
    echo "  [Envoie CURL] : OK"
}

function main {
    local dev=false

    # Vérifier les options passées
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                afficher_aide
                exit 0
                ;;
            --dev)
                dev=true
                ;;
            *)
                echo "Option non reconnue: $1"
                afficher_aide
                exit 1
                ;;
        esac
        shift
    done

    recup_module "$dev"
}

main "$@"