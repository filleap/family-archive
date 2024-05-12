# family-archive
Ce projet utilise le [service GLACIER de scaleway](https://www.scaleway.com/fr/glacier-cold-storage/) qui permet de sauvegarder des fichiers dans un environnement dont le coût de stockage est très peu cher (# 0,25€/mois pour 100Go). Il faut néanmoins prendre en compte des frais de bande passante pour récupérer ses données (# 0,01€/Go).

Ce projet utilise podman pour créer une conteneur qui disposera du CLI scalingo et se chargera de récupérer les fichiers et de les envoyer vers le services GLACIER.

***

Nous partirons d'une image linux alipne et installerons automatiquement le CLI scaleway.

Scaleway fourni une image podman de son CLI. La configuration proposée est d'effectuer un point de montage sur le répertoire de ocnfiguration local. Cette configuration n'est pas portable et présente le défaut de créer un point de connexion entre le conteneur et la machine hôte.

Nous allons plutôt inclure le fichier de configuration en créant une image à partir de celle fournie par scaleway. 
