# family-archive
Ce projet utilise le [service GLACIER de scaleway](https://www.scaleway.com/fr/glacier-cold-storage/) qui permet de sauvegarder des fichiers dans un environnement dont le coût de stockage est très peu cher (# 0,25€/mois pour 100Go). Il faut néanmoins prendre en compte des frais de bande passante pour récupérer ses données (# 0,01€/Go).

Ce projet utilise `restic` pour la gestion des sauvegardes et `rclone` pour la connexion et la synchronisation des fichiers dans le bucket S3.

***
## rclone
Nous supposerons que `rclone` est déjà installé et opérationnel. Dans le cas contraire, les différentes méthoddes d'installation sont décrites dans [la documentation](https://rclone.org/install/).

La première étape consiste à configurer `rclone` en fonction du type et/ou du fournisseur de stockage choisi. Dans le cas présent, nous allons suivre les indications propores à disponible dans la [documentation `Object Storage` de scaleway](https://www.scaleway.com/en/docs/storage/object/api-cli/installing-rclone/).

Il est conseillé de noter les clés d'API dans un fichier car elles ne sont plus disponibles par la suite. En cas de perte, il faudra en générer de nouvelles et reprender la configuration de `rclone`. L'application ou l'utilisateur doivent avoir les autorisation suffisantes pour accéder au bucket.

## restic
Nous supposerons que `restic` est déjà installé et opérationnel. Dans le cas contraire, les différentes méthoddes d'installation sont décrites dans [la documentation](https://restic.readthedocs.io/en/stable/020_installation.html).

Pour l'utilisation d'un stockage `rclone`, il faut suivre la [configuration décrite dans la documentation](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#other-services-via-rclone).

On utilise la commande suivante pour initialiser un répertoire local comme point d'accès vers le bucket.

```bash
restic -r rclone:<remote-name>:<bucket-name> init
```
Le `remote-name` est le nom défini au moment de la configuration de `rclone` et le `bucket-name` est le nom choisi lors de la création du stockage objet via l'interface ou le CLI de scaleway.

Le lancement d'une sauvegarde se fait à l'aide de la commande

```bash
restic -r rclone:<remote-name>:<bucket-name> backup <path-to-backup>
```

Les autres commandes disponibles sont décrites [dans la documentation](https://restic.readthedocs.io/en/stable/index.html#).