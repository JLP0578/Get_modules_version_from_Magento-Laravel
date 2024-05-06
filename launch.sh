#!/bin/bash

source ./launch.env

function afficher_aide {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help           Obtenir de l'aide sur les commandes"
    echo "  -m, --magento        Récupération des modules pour le projet Magento"
    echo "  -l, --laravel        Récupération des modules pour le projet Laravel"
    echo "  --dev                Utilisation du BO dev"
}

function recup_module_magento {
    echo "Lancement de la récupération des modules pour le projet Magento..."

    argument=$PROD_ARGUMENT
    if [[ "$dev" == true ]]; then
        argument=$DEV_ARGUMENT
    fi

    echo "[Execute Docker] : $MAGENTO_NAME"
    docker run --rm --name $MAGENTO_NAME --network $NETWORK -v $MAGENTO_LOCALCOMPOSERJSON:$CONTAINERCOMPOSERJSON:$READONLY -v $MAGENTO_LOCALCOMPOSERLOCK:$CONTAINERCOMPOSERLOCK:$READONLY -v $LOCALPROCESSSH:$CONTAINERPROCESSSH -v $LOCALENV:$CONTAINERENV -it $IMAGE sh -c "$argument"
}

function recup_module_laravel {
    echo "Lancement de la récupération des modules pour le projet Laravel..."

    argument=$PROD_ARGUMENT
    if [[ "$dev" == true ]]; then
        argument=$DEV_ARGUMENT
    fi

    echo "[Execute Docker] : $LARAVEL_NAME"
    docker run --rm --name $LARAVEL_NAME --network $NETWORK -v $LARAVEL_LOCALCOMPOSERJSON:$CONTAINERCOMPOSERJSON:$READONLY -v $LARAVEL_LOCALCOMPOSERLOCK:$CONTAINERCOMPOSERLOCK:$READONLY -v $LOCALPROCESSSH:$CONTAINERPROCESSSH -v $LOCALENV:$CONTAINERENV -it $IMAGE sh -c "$argument"
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
            -m|--magento)
                magento=true
                ;;
            -l|--laravel)
                laravel=true
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

    if [[ "$magento" == true ]]; then
        recup_module_magento "$dev"
    fi

    if [[ "$laravel" == true ]]; then
        recup_module_laravel "$dev"
    fi

    if [[ "$magento" == false && "$laravel" == false ]]; then
        echo "Aucune option spécifiée. Utilisez -h ou --help pour afficher l'aide."
        afficher_aide
        exit 1
    fi
}

main "$@"