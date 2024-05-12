#!/bin/bash
source .env
pwd=$(pwd)

echo "#### Configuration de l'environnement scaleway ####"
cp config_scw_empty.yaml config_scw.yaml
echo "    access_key: ${ACCESS_KEY}" >> config_scw.yaml
echo "    secret_key: ${SECRET_KEY}" >> config_scw.yaml
echo "    default_organization_id: ${ORGANIZATION_ID}" >> config_scw.yaml
echo "    default_project_id: ${PROJECT_ID}" >> config_scw.yaml
echo "    default_zone: ${ZONE}" >> config_scw.yaml
echo "    default_region: ${REGION}" >> config_scw.yaml

echo "#### Configuration de l'environnement S3 ####"
cp credentials_aws_empty credentials_aws
echo "aws_access_key_id=${ACCESS_KEY}" >> credentials_aws
echo "aws_secret_access_key=${SECRET_KEY}" >> credentials_aws

echo "#### Suppression des fichiers ####"
if [ $(rm $pwd/deploy/scw-cli.tar) ]; then
    echo "#### Fichier tar supprimé ####"
    if [ $(rm $pwd/deploy/scw-clie.md5) ]; then
        echo "#### Fichier md5 supprimé ####"
        if [ $(podman rmi localhost/scw-cli) ]; then
            echo "#### Image supprimée ####"
        fi
    fi
fi

echo "#### Construction de l'image ####"
podman build . -t localhost/scw-cli
podman save -o $pwd/deploy/scw-cli.tar localhost/scw-cli:latest
md5sum $pwd/deploy/scw-cli.tar > $pwd/deploy/scw-cli.md5
