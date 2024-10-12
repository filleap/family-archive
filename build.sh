    n#!/bin/bash
source .env_rclone
pwd=$(pwd)

echo "#### Configuration de l'environnement scaleway ####"
touch config_scw.yaml
echo "    access_key: ${ACCESS_KEY}" >> config_scw.yaml
echo "    secret_key: ${SECRET_KEY}" >> config_scw.yaml
echo "    default_organization_id: ${ORGANIZATION_ID}" >> config_scw.yaml
echo "    default_project_id: ${PROJECT_ID}" >> config_scw.yaml
echo "    default_zone: ${ZONE}" >> config_scw.yaml
echo "    default_region: ${REGION}" >> config_scw.yaml
echo "    api_url: ${API_URL}" >> config_scw.yaml

echo "#### Configuration de rclone ####"
touch rclone.conf
echo "[${S3_BUCKET}]" >> rclone.conf
echo "type = s3" >> rclone.conf
echo "env_auth = false" >> rclone.conf
echo "endpoint = s3.fr-par.scw.cloud" >> rclone.conf
echo "access_key_id = ${ACCESS_KEY}" >> rclone.conf
echo "secret_access_key = ${SECRET_KEY}" >> rclone.conf
echo "region = fr-par" >> rclone.conf
echo "location_constraint =" >> rclone.conf
echo "acl = private" >> rclone.conf
echo "force_path_style = false" >> rclone.conf
echo "server_side_encryption =" >> rclone.conf
echo "storage_class = ${STORAGE_CLASS}" >> rclone.conf

echo "#### Suppression des fichiers images podman ####"
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

echo "#### Delete config files ####"
rm rclone.conf
rm config_scw.yaml

