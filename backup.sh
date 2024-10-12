#!/bin/sh

source .env

for dir in ${DIRECTORIES[@]}; do
    echo "#### backup $dir ###"
    restic --repo $RESTIC_REPOSITORY --password-file restic_pwd.cfg backup "$ROOT_FOLDER/$dir"
done
