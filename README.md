# Versioning des Modules Magento & Laravel

Le container docker pour le versioning en est à sa première version.


| Type             | Nom                                         | Version |
| ---------------- | ------------------------------------------- | ------- |
| Container Docker | `versioning_composer_magento` & `versioning_composer_laravel` & `versioning_composer_script` | v1      |
| Script`.sh`      | `launch.sh` & `process.sh`                  | v1      |

## Composer

### `launch.sh`

Le script `launch.sh` peut actuellement prendre trois options :


| raccourci | option      | Description                                       |
| --------- | ----------- | ------------------------------------------------- |
| `-h`      | `--help`    | Optenir de l'aide sur les commandes               |
| `-m`      | `--magento` | Récupération des modules pour le projet Magento   |
| `-l`      | `--laravel` | Récupération des modules pour le projet Laravel   |
| `-s`      | `--script`  | Récupération des modules pour les Scripts         |
| Ø         | `--dev`     | Permet d'utiliser le BO dev                       |
| Ø        | `--by-cron`     | Permet d'utiliser le crontab                       |

Exemple :

- Je souhaite exécuter le script `launch.sh` pour mon **Magento** pour qu'il affiche le résultat dans le **BO de prod**.

  Je vais faire `./launch.sh --magento` ou `./launch.sh -m` pour les presser.
- Je souhaite exécuter le script `launch.sh` pour mon **Magento** et mon **Laravel** pour qu'il affiche le résultat dans le **BO de dev**.

  Je vais faire `./launch.sh --magento --laravel --dev` ou `./launch.sh -m -l --dev` pour les presser.

### `process.sh`

Le script `launch.sh` peut actuellement prendre une option :


| raccourci | option   | Description                         |
| --------- | -------- | ----------------------------------- |
| `-h`      | `--help` | Optenir de l'aide sur les commandes |
| Ø         | `--dev`  | Permet d'utiliser le BO dev         |

Exemple :

- Je souhaite exécuter le script `process.sh` pour qu'il affiche le résultat dans le **BO de dev**.

  Je vais faire un `./process.sh --dev`

### Les `.env`

Il y a deux `.env` dans la procédure complète, le `.launch.env` et le `.process.env`.

Tous les deux nécessaires au bon fonctionnement de la procédure, voici les détails :

Pour `.launch.env`


| Nom                         | Description                                                                         |
| --------------------------- | ----------------------------------------------------------------------------------- |
| `MAGENTO_NAME`              | Nom du container docker pour Magento (ex :`versioning_magento`)                     |
| `MAGENTO_LOCALCOMPOSERJSON` | Chemin local de votre`composer.json` de Magento                                     |
| `MAGENTO_LOCALCOMPOSERLOCK` | Chemin local de votre`composer.lock` de Magento                                     |
| `MAGENTO_LOCALAUTHJSON`     | Chemin local de votre`auth.json` de Magento                                         |
| `LARAVEL_NAME`              | Nom du container docker pour Laravel (ex :`versioning_laravel`)                     |
| `LARAVEL_LOCALCOMPOSERJSON` | Chemin local de votre`composer.json` de Laravel                                     |
| `LARAVEL_LOCALCOMPOSERLOCK` | Chemin local de votre`composer.json` de Laravel                                     |
| `SCRIPT_NAME_1`              | Nom du container docker pour le script 1 (ex :`versioning_composer_script_1`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_1`  | Chemin local de votre`composer.json` dede votre script 1                                |
| `SCRIPT_LOCALCOMPOSERLOCK_1`  | Chemin local de votre`composer.lock` dede votre script 1                           |
| `SCRIPT_NAME_2`              | Nom du container docker pour le script 2 (ex :`versioning_composer_script_2`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_2`  | Chemin local de votre`composer.json` dede votre script 2                                |
| `SCRIPT_LOCALCOMPOSERLOCK_2`  | Chemin local de votre`composer.lock` dede votre script 2                           |
| `SCRIPT_NAME_3`              | Nom du container docker pour le script 3 (ex :`versioning_composer_script_3`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_3`  | Chemin local de votre`composer.json` dede votre script 3                                |
| `SCRIPT_LOCALCOMPOSERLOCK_3`  | Chemin local de votre`composer.lock` dede votre script 3                           |
| `SCRIPT_NAME_4`              | Nom du container docker pour le script 4 (ex :`versioning_composer_script_4`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_4`  | Chemin local de votre`composer.json` dede votre script 4                                |
| `SCRIPT_LOCALCOMPOSERLOCK_4`  | Chemin local de votre`composer.lock` dede votre script 4                           |
| `SCRIPT_NAME_5`              | Nom du container docker pour le script 5 (ex :`versioning_composer_script_5`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_5`  | Chemin local de votre`composer.json` dede votre script 5                                |
| `SCRIPT_LOCALCOMPOSERLOCK_5`  | Chemin local de votre`composer.lock` dede votre script 5                           |
| `SCRIPT_NAME_6`              | Nom du container docker pour le script 6 (ex :`versioning_composer_script_6`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_6`  | Chemin local de votre`composer.json` dede votre script 6                                |
| `SCRIPT_LOCALCOMPOSERLOCK_6`  | Chemin local de votre`composer.lock` dede votre script 6                           |
| `SCRIPT_NAME_7`              | Nom du container docker pour le script 7 (ex :`versioning_composer_script_7`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_7`  | Chemin local de votre`composer.json` dede votre script 7                                |
| `SCRIPT_LOCALCOMPOSERLOCK_7`  | Chemin local de votre`composer.lock` dede votre script 7                           |
| `SCRIPT_NAME_8`              | Nom du container docker pour le script 8 (ex :`versioning_composer_script_8`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_8`  | Chemin local de votre`composer.json` dede votre script 8                                |
| `SCRIPT_LOCALCOMPOSERLOCK_8`  | Chemin local de votre`composer.lock` dede votre script 8                           |
| `SCRIPT_NAME_9`              | Nom du container docker pour le script 9 (ex :`versioning_composer_script_9`)                   |
| `SCRIPT_LOCALCOMPOSERJSON_9`  | Chemin local de votre`composer.json` dede votre script 9                                |
| `SCRIPT_LOCALCOMPOSERLOCK_9`  | Chemin local de votre`composer.lock` dede votre script 9                           |
| `SCRIPT_NAME_10`             | Nom du container docker pour le script 10 (ex :`versioning_composer_script_10`)                 |
| `SCRIPT_LOCALCOMPOSERJSON_10` | Chemin local de votre`composer.json` dede votre script 10                               |
| `SCRIPT_LOCALCOMPOSERLOCK_10` | Chemin local de votre`composer.lock` dede votre script 10                          |
| `CONTAINERCOMPOSERJSON`     | Chemin dans le container pour votre`composer.json` (ex : `/app/composer.json`)      |
| `CONTAINERCOMPOSERLOCK`     | Chemin dans le container pour votre`composer.lock` (ex : `/app/composer.lock`)      |
| `CONTAINERAUTHJSON`         | Chemin dans le container pour votre`auth.json` (ex : `/app/auth.json`)              |
| `CONTAINERPROCESSSH`        | Chemin dans le container pour votre`process.sh` (ex : `/app/process.sh`)            |
| `LOCALPROCESSSH`            | Chemin local de votre`process.sh`                                                   |
| `LOCALENV`                  | Chemin local de votre`.process.env`                                                 |
| `CONTAINERENV`              | Chemin dans le container pour votre`.process.env` (ex : `/app/.process.env`)        |
| `PROD_ARGUMENT`             | Commande d'execution du script`process.sh`pour la prod (ex :`/app/process.sh`)      |
| `DEV_ARGUMENT`              | Commande d'execution du script`process.sh` pour le dev(ex :`/app/process.sh --dev`) |
| `READONLY`                  | Suffix pour monter les fichiers en Read Only (ex :`ro`)                             |
| `IMAGE`                     | Image à utiliser pour faire la procédure (ex :`composer:2.7.4`)                     |
| `NETWORK`                   | Nom du NetWork docker à associer (ex :`local_host`)                                 |

Pour `.process.env`


| Nom                          | Description                                                           |
| ---------------------------- | --------------------------------------------------------------------- |
| `PROD_IP`                    | IP de la prod                                                         |
| `PROD_DOMAINE`               | URL du domaine de prod (ex :`https://domaine.com`)                    |
| `PROD_TOKEN_VERSIONING`      | Le token de connexion a l'API Verisoning Laravel de prod              |
| `PROD_URI_VERSIONING`        | URI de la route API versioning prod (ex :`/api/votre/route/api`)      |
| `PROD_TOKEN_ERRORMONITORING` | Le token de connexion a l'API errorMonitoring Laravel de prod         |
| `PROD_URI_ERRORMONITORING`   | URI de la route API errorMonitoring prod (ex :`/api/votre/route/api`) |
| `DEV_IP`                     | IP de dev                                                             |
| `DEV_DOMAINE`                | URL du domaine de dev (ex :`https://domaine.com`)                     |
| `DEV_TOKEN_VERSIONING`       | Le token de connexion a l'API Verisoning Laravel de dev               |
| `DEV_URI_VERSIONING`         | URI de la route API versioning dev (ex :`/api/votre/route/api`)       |
| `DEV_TOKEN_ERRORMONITORING`  | Le token de connexion a l'API errorMonitoring Laravel de dev          |
| `DEV_URI_ERRORMONITORING`    | URI de la route API errorMonitoring prod (ex :`/api/votre/route/api`) |

### Procedure complète

Exécution du script `launch.sh` par le crontab (avec les options que l'on souhaite)

Le script va alors lancer le container docker pour chaque environnement. (Magento &| Laravel &| Script).

Les fichiers `composer.json`, `composer.lock`, et `auth.json` (pour Magento uniquement) vont être pré chargé dans le container en plus du `process.sh` et du `.process.env`.

Une fois lancer, il va exécuter le script `process.sh` dans le container, il récupère les infos sur les modules installés, les traites et les envois à l'API Laravel. (dev | prod)

La récupération se fait en trois phases, les majeurs, les mineurs et les patch, ce qui permet d'avoir les modules avec le plus petit changement en dernier.
