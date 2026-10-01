# Crafty Controller pour fnOS

Ce projet empaquette Crafty Controller comme application Docker fnOS avec `fnpack`.

## Construction

Sur une machine Linux x86_64 :

```bash
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-linux-amd64
chmod +x fnpack
sudo mv fnpack /usr/local/bin/fnpack
chmod +x build.sh cmd/*
./build.sh
```

Le fichier `.fpk` est généré par `fnpack` dans le dossier du projet.

## Installation

Installe le fichier `.fpk` depuis le centre d'applications fnOS. L'interface Crafty est ensuite disponible sur :

- HTTP : `http://IP_DU_NAS:8000`
- HTTPS : `https://IP_DU_NAS:8443`

Les données sont conservées dans `/var/lib/fnos/apps/crafty-controller`.

## Important

Le paquet utilise l'image Docker Crafty officielle publiée sur GitLab. Le NAS doit avoir Docker/Compose et un accès réseau pour télécharger l'image. Le montage de `docker.sock` donne au conteneur un contrôle élevé sur Docker : ne publie pas l'interface directement sur Internet.

Le build doit être exécuté avec le vrai binaire `fnpack`; je ne peux pas produire le binaire `.fpk` depuis l'API GitHub seule.
