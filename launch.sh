#!/bin/bash

source ./.launch.env

function afficher_aide {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help           Obtenir de l'aide sur les commandes"
    echo "  -l, --laravel        Récupération des modules pour le projet Laravel"
    echo "  -s, --script         Récupération des modules pour les Scripts"
    echo "  --dev                Utilisation du BO dev"
    echo "  --by-cron            Utilisation de l'option -d"
}

function recup_module_script {
    echo "Lancement de la récupération des modules pour le Script..."

    option="-it"
    if [[ "$by_cron" == true ]]; then
        option="-d"
    fi

    argument=$PROD_ARGUMENT
    if [[ "$dev" == true ]]; then
        argument=$DEV_ARGUMENT
    fi

    
    # Boucle pour tester les variables SCRIPT_NAME_1 à SCRIPT_NAME_10
    for i in {1..10}; do
        # Récupérer le nom de la variable
        script_name_var="SCRIPT_NAME_$i"
        script_package_json_var="SCRIPT_LOCALSCRIPTJSON_$i"
        script_package_lock_json_var="SCRIPT_LOCALSCRIPTLOCK_$i"
        
        # Récupérer la valeur de la variable SCRIPT_NAME
        script_name_value="${!script_name_var}"
        script_package_json_value="${!script_package_json_var}"
        script_package_lock_json_value="${!script_package_lock_json_var}"

        # Vérifier si l'une des variables est vide, si oui, sortir de la boucle
        if [ -z "$script_name_value" ] || [ -z "$script_package_json_value" ] || [ -z "$script_package_lock_json_value" ]; then
            echo "Il y a plus de Script a récupérer. Arrêt de la boucle."
            break
        fi

        # Exécuter la commande Docker
        echo "[Execute Docker] : $script_name_value"
        docker run --rm --name $script_name_value -e CONTAINER_NAME=$script_name_value --network $NETWORK -v $script_package_json_value:$CONTAINERPACKAGEJSON:$READONLY -v $script_package_lock_json_value:$CONTAINERPACKAGELOCK:$READONLY -v $LOCALPROCESSSH:$CONTAINERPROCESSSH -v $LOCALENV:$CONTAINERENV -it $IMAGE sh -c "$argument"

        # Vérifier que le processus Docker précédent s'est terminé avant de continuer
        docker_exit_code=$?
        if [ $docker_exit_code -ne 0 ]; then
            echo "Erreur : Docker a échoué avec le code de sortie $docker_exit_code. Arrêt de la boucle."
            break
        fi
    done
}

function recup_module_laravel {
    echo "Lancement de la récupération des modules pour le projet Laravel..."

    option="-it"
    if [[ "$by_cron" == true ]]; then
        option="-d"
    fi

    argument=$PROD_ARGUMENT
    if [[ "$dev" == true ]]; then
        argument=$DEV_ARGUMENT
    fi

    echo "[Execute Docker] : $LARAVEL_NAME"
    docker run --rm --name $LARAVEL_NAME -e CONTAINER_NAME=$LARAVEL_NAME --network $NETWORK -v $LARAVEL_LOCALPACKAGEJSON:$CONTAINERPACKAGEJSON:$READONLY -v $LARAVEL_LOCALPACKAGELOCK:$CONTAINERPACKAGELOCK:$READONLY -v $LOCALPROCESSSH:$CONTAINERPROCESSSH -v $LOCALENV:$CONTAINERENV $option $IMAGE sh -c "$argument"
}

function main {
    local laravel=false
    local script=false
    local dev=false
    local by_cron=false

    # Vérifier les options passées
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                afficher_aide
                exit 0
                ;;
            -l|--laravel)
                laravel=true
                ;;
            -s|--script)
                script=true
                ;;
            --dev)
                dev=true
                ;;
            --by-cron)
                by_cron=true
                ;;
            *)
                echo "Option non reconnue: $1"
                afficher_aide
                exit 1
                ;;
        esac
        shift
    done

    if [[ "$laravel" == true ]]; then
        recup_module_laravel "$dev" "$by_cron"
    fi

    if [[ "$script" == true ]]; then
        recup_module_script "$dev" "$by_cron"
    fi

    if [[ "$laravel" == false && "$script" == false ]]; then
        echo "Aucune option spécifiée. Utilisez -h ou --help pour afficher l'aide."
        afficher_aide
        exit 1
    fi
}

main "$@"
