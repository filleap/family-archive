#!/bin/bash

source .env

# Définir le répertoire à parcourir qui est le point de montage du conteneur
repertoire="archives"

# Vérifier si le répertoire existe
if [ ! -d "$repertoire" ]; then
    echo "Le répertoire $repertoire n'existe pas."
    exit 1
fi

# Lancement de la synchronisation rclone
rclone sync -v ./$repertoire/ $S3_BUCKET:/$S3_FOLDER/ --update