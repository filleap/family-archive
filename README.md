# family-archive
Ce projet utilise le [service GLACIER de scaleway](https://www.scaleway.com/fr/glacier-cold-storage/) qui permet de sauvegarder des fichiers dans un environnement dont le coût de stockage est très peu cher (# 0,25€/mois pour 100Go). Il faut néanmoins prendre en compte des frais de bande passante pour récupérer ses données (# 0,01€/Go).

Ce projet utilise podman pour créer une conteneur qui disposera du CLI scalingo et se chargera de récupérer les fichiers et de les envoyer vers le services GLACIER.

***

Nous partirons d'une image linux python et installerons automatiquement le CLI scaleway.

Le fichier `.env` contient l'ensemble des paramètres de configuration. Il est utilisé au moment de la construction de l'image. Le script `build.sh` permet de construire les fichiers de configuration `config_scw_empty` et `credentials_aws` puis de lancer la construction de l'image à l'aide de podman.

Le fichier `Containerfile` décrit les différentes étapes de la ocnstruction de l'image. Celle-ci contient tout les éléments nécessaires au fonctionnement et n'a pas besoin de point de montage sur l'hôte pour fonctionner.

La commande pour lancer l'archivage en revanche repose sur un montage sur le disque de l'hôte où se trouve les fichiers à archiver. Elle utilise le script `archive.sh` passé en paramètre du lancement du conteneur `scw-cli` construit dans l'étape précédente.

```bash
podman run -it --rm -v /path_to_files/:/tmp/scw-cli/archives localhost/scw-cli ./archive.sh
```

Le scipt `archive.sh` archive tous les fichiers et répertoires présents dans le répertoire `/tmp/scw-cli/archives` local au conteneur. Il faut donc que les fichiers à archiver soient montés sur ce répertoire pour pouvoir être envoyés vers le bucket S3 GLACIER.