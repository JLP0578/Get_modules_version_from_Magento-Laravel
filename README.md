# Versioning des Modules Laravel & Script

Le container docker pour le versioning en est à sa première version.


| Type             | Nom                                         | Version |
| ---------------- | ------------------------------------------- | ------- |
| Container Docker | `versioning_node_laravel` & `versioning_node_script`  | v1      |
| Script`.sh`      | `launch.sh` & `process.sh`                  | v1      |

## Composer

### `launch.sh`

Le script `launch.sh` peut actuellement prendre trois options :


| raccourci | option      | Description                                       |
| ----------- | ------------- | --------------------------------------------------- |
| `-h`      | `--help`    | Optenir de l'aide sur les commandes               |
| `-l`      | `--laravel` | Récupération des modules pour le projet Laravel |
| `-s`      | `--script`  | Récupération des modules pour les Scripts         |
| Ø        | `--dev`     | Permet d'utiliser le BO dev                       |
| Ø        | `--by-cron`     | Permet d'utiliser le crontab                       |

Exemple :

- Je souhaite exécuter le script `launch.sh` pour mon **Laravel** pour qu'il affiche le résultat dans le **BO de prod**.

  Je vais faire `./launch.sh --laravel` ou `./launch.sh -m` pour les presser.
- Je souhaite exécuter le script `launch.sh` pour mon **Laravel** et mon **Script** pour qu'il affiche le résultat dans le **BO de dev**.

  Je vais faire `./launch.sh --laravel --script --dev` ou `./launch.sh -l -s --dev` pour les presser.

### `process.sh`

Le script `launch.sh` peut actuellement prendre une option :


| raccourci | option   | Description                         |
| ----------- | ---------- | ------------------------------------- |
| `-h`      | `--help` | Optenir de l'aide sur les commandes |
| Ø        | `--dev`  | Permet d'utiliser le BO dev         |

Exemple :

- Je souhaite exécuter le script `process.sh` pour qu'il affiche le résultat dans le **BO de dev**.

Je vais faire un `./process.sh --dev`

### Les `.env`

Il y a deux `.env` dans la procédure complète, le `.launch.env` et le `.process.env`.

Tous les deux nécessaires au bon fonctionnement de la procédure, voici les détails :

Pour `.launch.env`


| Nom                          | Description                                                                            |
| ------------------------------ | ---------------------------------------------------------------------------------------- |
| `LARAVEL_NAME`               | Nom du container docker pour Laravel (ex :`versioning_laravel`)                        |
| `LARAVEL_LOCALPACKAGEJSON`   | Chemin local de votre`package.json` de Laravel                                         |
| `LARAVEL_LOCALPACKAGELOCK`   | Chemin local de votre`package.json` de Laravel                                         |
| `SCRIPT_NAME_1`              | Nom du container docker pour le script 1 (ex :`versioning_node_script_1`)                   |
| `SCRIPT_LOCALPACKAGEJSON_1`  | Chemin local de votre`package.json` dede votre script 1                                |
| `SCRIPT_LOCALPACKAGELOCK_1`  | Chemin local de votre`package-lock.json` dede votre script 1                           |
| `SCRIPT_NAME_2`              | Nom du container docker pour le script 2 (ex :`versioning_node_script_2`)                   |
| `SCRIPT_LOCALPACKAGEJSON_2`  | Chemin local de votre`package.json` dede votre script 2                                |
| `SCRIPT_LOCALPACKAGELOCK_2`  | Chemin local de votre`package-lock.json` dede votre script 2                           |
| `SCRIPT_NAME_3`              | Nom du container docker pour le script 3 (ex :`versioning_node_script_3`)                   |
| `SCRIPT_LOCALPACKAGEJSON_3`  | Chemin local de votre`package.json` dede votre script 3                                |
| `SCRIPT_LOCALPACKAGELOCK_3`  | Chemin local de votre`package-lock.json` dede votre script 3                           |
| `SCRIPT_NAME_4`              | Nom du container docker pour le script 4 (ex :`versioning_node_script_4`)                   |
| `SCRIPT_LOCALPACKAGEJSON_4`  | Chemin local de votre`package.json` dede votre script 4                                |
| `SCRIPT_LOCALPACKAGELOCK_4`  | Chemin local de votre`package-lock.json` dede votre script 4                           |
| `SCRIPT_NAME_5`              | Nom du container docker pour le script 5 (ex :`versioning_node_script_5`)                   |
| `SCRIPT_LOCALPACKAGEJSON_5`  | Chemin local de votre`package.json` dede votre script 5                                |
| `SCRIPT_LOCALPACKAGELOCK_5`  | Chemin local de votre`package-lock.json` dede votre script 5                           |
| `SCRIPT_NAME_6`              | Nom du container docker pour le script 6 (ex :`versioning_node_script_6`)                   |
| `SCRIPT_LOCALPACKAGEJSON_6`  | Chemin local de votre`package.json` dede votre script 6                                |
| `SCRIPT_LOCALPACKAGELOCK_6`  | Chemin local de votre`package-lock.json` dede votre script 6                           |
| `SCRIPT_NAME_7`              | Nom du container docker pour le script 7 (ex :`versioning_node_script_7`)                   |
| `SCRIPT_LOCALPACKAGEJSON_7`  | Chemin local de votre`package.json` dede votre script 7                                |
| `SCRIPT_LOCALPACKAGELOCK_7`  | Chemin local de votre`package-lock.json` dede votre script 7                           |
| `SCRIPT_NAME_8`              | Nom du container docker pour le script 8 (ex :`versioning_node_script_8`)                   |
| `SCRIPT_LOCALPACKAGEJSON_8`  | Chemin local de votre`package.json` dede votre script 8                                |
| `SCRIPT_LOCALPACKAGELOCK_8`  | Chemin local de votre`package-lock.json` dede votre script 8                           |
| `SCRIPT_NAME_9`              | Nom du container docker pour le script 9 (ex :`versioning_node_script_9`)                   |
| `SCRIPT_LOCALPACKAGEJSON_9`  | Chemin local de votre`package.json` dede votre script 9                                |
| `SCRIPT_LOCALPACKAGELOCK_9`  | Chemin local de votre`package-lock.json` dede votre script 9                           |
| `SCRIPT_NAME_10`             | Nom du container docker pour le script 10 (ex :`versioning_node_script_10`)                 |
| `SCRIPT_LOCALPACKAGEJSON_10` | Chemin local de votre`package.json` dede votre script 10                               |
| `SCRIPT_LOCALPACKAGELOCK_10` | Chemin local de votre`package-lock.json` dede votre script 10                          |
| `CONTAINERPACKAGEJSON`       | Chemin dans le container pour votre`package.json` (ex : `/app/package.json`)           |
| `CONTAINERPACKAGELOCK`       | Chemin dans le container pour votre`package-lock.json` (ex : `/app/package-lock.json`) |
| `CONTAINERPROCESSSH`         | Chemin dans le container pour votre`process.sh` (ex : `/app/process.sh`)               |
| `LOCALPROCESSSH`             | Chemin local de votre`process.sh`                                                      |
| `LOCALENV`                   | Chemin local de votre`.process.env`                                                    |
| `CONTAINERENV`               | Chemin dans le container pour votre`.process.env` (ex : `/app/.process.env`)           |
| `INSTALL_BASH`               | Commande d'execution des installation pour le fonctionnement de`process.sh`            |
| `PROD_ARGUMENT`              | Commande d'execution du script`process.sh`pour la prod (ex :`/app/process.sh`)         |
| `DEV_ARGUMENT`               | Commande d'execution du script`process.sh` pour le dev(ex :`/app/process.sh --dev`)    |
| `READONLY`                   | Suffix pour monter les fichiers en Read Only (ex :`ro`)                                |
| `IMAGE`                      | Image à utiliser pour faire la procédure (ex :`node:lts-alpine3.20`)                   |
| `NETWORK`                    | Nom du NetWork docker à associer (ex :`local_host`)                                    |

Pour `.process.env`


| Nom                          | Description                                                           |
| ------------------------------ | ----------------------------------------------------------------------- |
| `PROD_IP`                    | IP de la prod                                                         |
| `PROD_DOMAINE`               | URL du domaine de prod (ex :`https://domaine.com`)                    |
| `PROD_TOKEN_VERSIONING`      | Le token de connexion a l'API Verisoning Laravel de prod              |
| `PROD_URI_VERSIONING`        | URI de la route API versioning prod (ex :`/api/votre/route/api`)      |
| `PROD_TOKEN_ERRORMONITORING` | Le token de connexion a l'API errorMonitoring Laravel de prod         |
| `PROD_URI_ERRORMONITORING`   | URI de la route API errorMonitoring prod (ex :`/api/votre/route/api`) |
| `DEV_DOMAINE`                | IP de dev                                                             |
| `DEV_DOMAINE`                | URL du domaine de dev (ex :`https://domaine.com`)                     |
| `DEV_TOKEN_VERSIONING`       | Le token de connexion a l'API Verisoning Laravel de dev               |
| `DEV_URI_VERSIONING`         | URI de la route API versioning dev (ex :`/api/votre/route/api`)       |
| `DEV_TOKEN_ERRORMONITORING`  | Le token de connexion a l'API errorMonitoring Laravel de dev          |
| `DEV_URI_ERRORMONITORING`    | URI de la route API errorMonitoring prod (ex :`/api/votre/route/api`) |

### Procedure complète

Exécution du script `launch.sh` par le crontab (avec les options que l'on souhaite)

Le script va alors lancer le container docker pour chaque environnement. (Magento &| Laravel).

Les fichiers `package.json` et `package-lock.json` (pour Magento uniquement) vont être pré chargé dans le container en plus du `process.sh` et du `.process.env`.

Une fois lancer, il va exécuter le script `process.sh` dans le container, il récupère les infos sur les modules installés, les traites et les envois à l'API Laravel. (dev | prod)

La récupération se fait en trois phases, les majeurs, les mineurs et les patch, ce qui permet d'avoir les modules avec le plus petit changement en dernier.