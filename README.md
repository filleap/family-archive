# family-archive
Ce projet utilise le [service GLACIER de scaleway](https://www.scaleway.com/fr/glacier-cold-storage/) qui permet de sauvegarder des fichiers dans un environnement dont le coût de stockage est très peu cher (# 0,25€/mois pour 100Go). Il faut néanmoins prendre en compte des frais de bande passante pour récupérer ses données (# 0,01€/Go).

Ce projet utilise `restic` pour la gestion des sauvegardes et `rclone` pour la connexion et la synchronisation des fichiers dans le bucket S3.

***
## rclone
Nous supposerons que `rclone` est déjà installé et opérationnel. Dans le cas contraire, les différentes méthoddes d'installation sont décrites dans [la documentation](https://rclone.org/install/).

La première étape consiste à configurer `rclone` en fonction du type et/ou du fournisseur de stockage choisi. Dans le cas présent, nous allons suivre les indications propores à disponible dans la [documentation `Object Storage` de scaleway](https://www.scaleway.com/en/docs/storage/object/api-cli/installing-rclone/).

Il est conseillé de noter les clés d'API dans un fichier car elles ne sont plus disponibles par la suite. En cas de perte, il faudra en générer de nouvelles et reprender la configuration de `rclone`. L'application ou l'utilisateur doivent avoir les autorisation suffisantes pour accéder au bucket.

`rclone`est capable d'accéder à plusieurs stockage s3 en précisant les configurations dans le fichier de configuration `ˇ/.config/rclone/rclone.conf` sous Linux. La syntaxe du fichier est

```conf
[bucket1]
type = s3
provider = Scaleway
access_key_id = <ACCESS_KEY1>
secret_access_key = <SECRET_KEY1>
region = fr-par
endpoint = s3.fr-par.scw.cloud
acl = private
storage_class = STANDARD
[bucket2]
type = s3
provider = Scaleway
access_key_id = <ACCESS_KEY2>
secret_access_key = <SECRET_KEY2>
region = fr-par
endpoint = s3.fr-par.scw.cloud
acl = private
storage_class = GLACIER
```

## restic
Nous supposerons que `restic` est déjà installé et opérationnel. Dans le cas contraire, les différentes méthoddes d'installation sont décrites dans [la documentation](https://restic.readthedocs.io/en/stable/020_installation.html).

Pour l'utilisation d'un stockage `rclone`, il faut suivre la [configuration décrite dans la documentation](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#other-services-via-rclone).

On utilise la commande suivante pour initialiser un répertoire local comme point d'accès vers le bucket.

```sh
restic -r rclone:<remote-name>:<bucket-name>/backups init
```

Le `remote-name` est le nom défini au moment de la configuration de `rclone` et le `bucket-name` est le nom choisi lors de la création du stockage objet via l'interface ou le CLI de scaleway.

Le lancement d'une sauvegarde se fait à l'aide de la commande

```sh
restic -r rclone:<remote-name>:<bucket-name> backup <path-to-backup>
```

Liste des snapshots

```sh
restic -r rclone:<remote-name>:<bucket-name> snapshots
```

Pour restaurer un backup

```sh
restic -r rclone:<remote-name>:<bucket-name> restore <backup-id> --target <path-to-restore>
```

Restauration sur un point de montage

```sh
mkdir /mnt/restic-restore
restic -r rclone:<remote-name>:<bucket-name> mount /mnt/restic-restore
```

Les autres commandes disponibles sont décrites [dans la documentation](https://restic.readthedocs.io/en/stable/index.html#).

## script de configuration

Pour faciliter l'usage de `restic` en ligne de commande, on peut définir les variables dans un fichier shell qui sera placé dans un répertoire du `$PATH` tel que `/usr/local/bin` pour les système Linux. Ce fichier aura comme template

```sh
#!/bin/sh

export RESTIC_REPOSITORY=<RESTIC_REPO>
export RESTIC_PASSWORD=<RESTIC_PASSWD>

exec restic "$@"
```

## script de backup

Le script `backup.sh` permet de lancer un backup automatique. Sa configuration est réalisée au travers du fichier `.env`. Un fichier `.env_sample` donne un exemple des différents paramètres à renseigner. Enfin, le fichier `restic_pwd.cfg` doit être présent et contenir uniquement le mot de passe de connexion au repo restic.

## restic browser
L'outil `restic-browser`premet de parcourir les backups et les fichiers qu'ils contiennent. L'interface graphique facilite l'usage manuel de `restic` sans pour autant permettre la création de backup.

Le dépôt GitHub du projet est https://github.com/emuell/restic-browser. L'application est disponible pour Windows, Mac et Linux. Pour ce dernier, elle est fournie sous forme d'App image.e