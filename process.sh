#!/bin/bash

source ./.process.env

function afficher_aide {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help           Obtenir de l'aide sur les commandes"
    echo "  --dev                Utilisation du BO dev"
}

function recup_module {
    # Se placer dans le répertoire /app
    cd /app || exit

    # TODO: Faire la mise en place des logs
    dossier="/app/logs"
    if [ ! -d "$dossier" ]; then
        mkdir -p "$dossier"
    fi


    token=$LOCAL_TOKEN
    destination_url=$PROD_DESTINATION_URL
    if [[ "$1" == true ]]; then
        destination_url=$DEV_DESTINATION_URL
        token=$DEV_TOKEN
    fi

    # Déclaration du tableau associatif
    declare -A tableau_assoc
    tableau_assoc["major"]="--major-only"
    tableau_assoc["minor"]="--minor-only"
    tableau_assoc["patch"]="--patch-only"

    # Boucle à travers les clés du tableau associatif
    for cle in "${!tableau_assoc[@]}"
    do
        echo "[$cle]";

        # Exécuter la commande composer outdated et stocker la sortie dans une variable
        composer_output=$(composer outdated --ignore-platform-reqs --direct --strict --locked "${tableau_assoc[$cle]}" --sort-by-age --no-interaction --no-plugins --no-scripts --no-cache --format json)
        echo "  [Récuppération Modules] : OK"

        # Supprimer les lignes avec les clés spécifiées du JSON
        modified_output=$(echo "$composer_output" | awk '!/("direct-dependency"|"homepage"|"release-age"|"latest-status"|"description"|"warning")/')
        echo "  [Traitement AWK] : OK"

        # Définir l'environnement
        environment=$(composer show -s --name-only)
        echo "  [Récuppération Nom du Projet] : OK"

        # Encapsuler le JSON modifié dans un nouvel objet JSON
        json_output="{\"environnement\": \"$environment\", \"severity\": \"$cle\", \"modules\": $modified_output}"
        echo "  [Traitement JSON] : OK"
        # echo $json_output

        # Envoyer la sortie via une requête curl (remplacez URL_DE_DESTINATION par l'URL de destination)
        curl -X POST -H "Authorization: Bearer $token" -H 'Content-Type: application/json' -d "$json_output" --insecure $destination_url 
        echo "  [Envoie CURL] : OK"
    done
}

function main {
    local magento=false
    local laravel=false
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