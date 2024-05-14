#!/bin/bash

source ./.process.env

function afficher_aide {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help           Obtenir de l'aide sur les commandes"
    echo "  --dev                Utilisation du BO dev"
}

function check {
    EXITCODE=$?
    if [ "$EXITCODE" -ne "0" ]; then
        destination_url='https://'$PROD_IP$PROD_URI_ERRORMONITORING
        host=$PROD_DOMAINE
        token=$PROD_TOKEN_ERRORMONITORING
        if [[ "$1" == true ]]; then
            destination_url='https://'$DEV_IP$DEV_URI_ERRORMONITORING
            host=$DEV_DOMAINE
            token=$DEV_TOKEN_ERRORMONITORING
        fi

        body="{\"task\": \"$2\", \"action\": \"$3\", \"error_log\": \"$EXITCODE\"}"

        #Appel curl à l'API errorMonitoring
        curl -s -o /dev/null -X POST -H "Authorization: Bearer $token" -H 'Content-Type: application/json' -H "Host: $host" -d "$body" --insecure $destination_url

        exit $EXITCODE
    fi
}

function recup_module {
    destination_url='https://'$PROD_IP$PROD_URI_ERRORMONITORING
    host=$PROD_DOMAINE
    token=$PROD_TOKEN_VERSIONING
    if [[ "$1" == true ]]; then
        destination_url='https://'$DEV_IP$DEV_URI_ERRORMONITORING
        host=$DEV_DOMAINE
        token=$DEV_TOKEN_VERSIONING
    fi

    # Se placer dans le répertoire /app
    cd /app
    check "$1" $CONTAINER_NAME $environment'_cd_app'
    echo "[Changement Dossier] : OK"

    # Déclaration du tableau associatif
    declare -A tableau_assoc
    tableau_assoc["major"]="--major-only"
    tableau_assoc["minor"]="--minor-only"
    tableau_assoc["patch"]="--patch-only"

    # Boucle à travers les clés du tableau associatif
    for cle in "${!tableau_assoc[@]}"
    do
        echo "[$cle]";

        # Définir l'environnement
        environment=$(composer show -s --name-only)
        check "$1" $CONTAINER_NAME $cle'_composer_show_name'
        echo "  [Récuppération Nom du Projet] : OK"
        
        # Exécuter la commande composer outdated et stocker la sortie dans une variable
        composer_output=$(composer outdated --ignore-platform-reqs --direct --strict --locked "${tableau_assoc[$cle]}" --no-interaction --no-plugins --no-scripts --no-cache --format json)
        echo "  [Récuppération Modules] : OK"

        # Encapsuler le JSON modifié dans un nouvel objet JSON
        json_output="{\"environnement\": \"$environment\", \"severity\": \"$cle\", \"modules\": $composer_output}"
        echo "  [Traitement JSON] : OK"

        # Envoyer la sortie via une requête curl (remplacez URL_DE_DESTINATION par l'URL de destination)
        curl -s -o /dev/null -X POST -H "Authorization: Bearer $token" -H 'Content-Type: application/json' -H "Host: $host" -d "$json_output" --insecure $destination_url 
        check "$1" $CONTAINER_NAME $cle'_curl'
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