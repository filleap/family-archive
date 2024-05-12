#!/bin/bash

source .env

aws s3api list-objects --bucket $S3_BUCKET

# Définir le répertoire à parcourir qui est le point de montage du conteneur
repertoire="archives"

# Vérifier si le répertoire existe
if [ ! -d "$repertoire" ]; then
    echo "Le répertoire $repertoire n'existe pas."
    exit 1
fi
# Fonction récursive pour parcourir les fichiers
parcourir_repertoire() {
    local rep="$1"
    for fichier in "$rep"/*; do
        if [ -f "$fichier" ]; then
            echo "Envoi du fichier "$fichier""
            aws s3api put-object --bucket $S3_BUCKET --key "$fichier" --storage-class GLACIER --body "$fichier"
            echo "==============================="
        elif [ -d "$fichier" ]; then
            parcourir_repertoire "$fichier"
        fi
    done
}

# Appeler la fonction pour parcourir le répertoire principal
parcourir_repertoire "$repertoire"
