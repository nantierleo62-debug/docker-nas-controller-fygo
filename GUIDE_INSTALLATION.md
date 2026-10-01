# Guide d'installation du paquet Crafty Controller pour Fygo OS

## Table des matières
1. [Prérequis](#prérequis)
2. [Télécharger fnpack](#télécharger-fnpack)
3. [Cloner le repository](#cloner-le-repository)
4. [Compiler le paquet FPK](#compiler-le-paquet-fpk)
5. [Installer sur ton NAS](#installer-sur-ton-nas)
6. [Accéder à Crafty](#accéder-à-crafty)
7. [Troubleshooting](#troubleshooting)

---

## Prérequis

### Sur ta machine de build (Linux, macOS ou Windows avec WSL)

- **Système** : Linux x86_64, macOS ou Windows (WSL2)
- **Outils requis** :
  - `curl` (pour télécharger fnpack)
  - `git` (pour cloner le repository)
  - Aucune dépendance de compilation (fnpack est un binaire précompilé)

### Sur ton NAS (Fygo OS)

- Architecture : **AMD64 / x86_64** (Intel Pentium compatible)
- Fygo OS 1.0 ou supérieur
- Docker et Docker Compose installés (normalement pré-installés)
- Connexion réseau fonctionnelle

---

## Télécharger fnpack

`fnpack` est l'outil officiel Fygo OS pour créer les paquets d'applications.

### Sur Linux x86_64

```bash
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-linux-amd64
chmod +x fnpack
sudo mv fnpack /usr/local/bin/fnpack
fnpack --help
```

### Sur macOS

#### Intel

```bash
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-darwin-amd64
chmod +x fnpack
sudo mv fnpack /usr/local/bin/fnpack
fnpack --help
```

#### Apple Silicon (M1/M2/M3)

```bash
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-darwin-arm64
chmod +x fnpack
sudo mv fnpack /usr/local/bin/fnpack
fnpack --help
```

### Sur Windows (WSL2)

```bash
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-linux-amd64
chmod +x fnpack
sudo mv fnpack /usr/local/bin/fnpack
fnpack --help
```

### Vérifier l'installation

```bash
fnpack --help
```

Tu devrais voir la version et les commandes disponibles.

---

## Cloner le repository

### Via git

```bash
git clone https://github.com/nantierleo62-debug/docker-nas-controller-fygo.git
cd docker-nas-controller-fygo
```

### Alternative : Télécharger le ZIP

1. Va sur https://github.com/nantierleo62-debug/docker-nas-controller-fygo
2. Clique sur `Code` → `Download ZIP`
3. Décompresse le fichier
4. Ouvre un terminal dans le dossier

---

## Compiler le paquet FPK

### Étape 1 : Prépare les scripts

```bash
chmod +x build.sh cmd/*
```

### Étape 2 : Crée les icônes (si absentes)

Le script `build.sh` génère automatiquement les icônes PNG minimales si elles n'existent pas.

### Étape 3 : Lance le build

```bash
./build.sh
```

Ou directement avec fnpack :

```bash
fnpack build
```

### Résultat

Un fichier `.fpk` est généré dans le répertoire courant :

```
crafty-controller-4.0.0-fnos.1-x86_64.fpk
```

Le nom peut varier selon la version dans le `manifest`.

---

## Installer sur ton NAS

### Méthode 1 : Via l'App Center Fygo OS

1. **Sur ton NAS**, ouvre le **Centre d'applications** (App Center)
2. Clique sur **Importer** ou **Installer depuis fichier**
3. Sélectionne le fichier `.fpk` que tu viens de compiler
4. Valide et attends la fin de l'installation

### Méthode 2 : Via SSH (ligne de commande)

```bash
# Depuis ta machine, copie le fichier FPK vers le NAS
scp crafty-controller-*.fpk root@192.168.1.X:/tmp/

# Connecte-toi au NAS
ssh root@192.168.1.X

# Installe le paquet
fnnas install /tmp/crafty-controller-*.fpk
```

*(Remplace `192.168.1.X` par l'IP de ton NAS)*

---

## Accéder à Crafty

Une fois l'installation terminée, Crafty Controller démarre automatiquement.

### Interface web

- **HTTP** : `http://192.168.1.X:8000`
- **HTTPS** : `https://192.168.1.X:8443`

*(Remplace `192.168.1.X` par l'IP de ton NAS)*

### Ports

- `8000` : Interface HTTP
- `8443` : Interface HTTPS
- `25500-25510` : Serveurs Minecraft Java
- `19132` : Serveur Bedrock (UDP)

---

## Premiers pas avec Crafty

1. **Accédez à l'interface web** : `http://192.168.1.X:8000`
2. **Créez un nouveau serveur** :
   - Type : Vanilla, Paper, Fabric, Forge
   - Version Minecraft
   - Port
3. **Démarrez le serveur** et consultez les logs
4. **Connectez des joueurs** à `192.168.1.X:25500`

---

## Troubleshooting

### Le build échoue avec "fnpack non trouvé"

```bash
# Vérifie que fnpack est bien installé
fnpack --help

# Si pas trouvé, installe-le manuellement dans le répertoire
curl -L -o fnpack https://static2.fnnas.com/fnpack/fnpack-1.2.1-linux-amd64
chmod +x fnpack
```

### Erreur lors du build : "Missing files"

Assure-toi que la structure est complète :

```bash
ls -la
# manifest (fichier)
# ICON.PNG (sera créé automatiquement)
# ICON_256.PNG (sera créé automatiquement)
# app/docker/docker-compose.yaml (existe)
# cmd/ (dossier avec tous les scripts)
# config/ (dossier avec privilege et resource)
# wizard/ (dossier, peut être vide)
```

### Le FPK ne s'installe pas sur le NAS

1. Vérifie que tu as **l'accès administrateur** sur le NAS
2. Vérifie que **Docker/Compose** sont installés :
   ```bash
   ssh root@192.168.1.X
   docker --version
   docker-compose --version
   ```
3. Consulte les logs d'installation :
   ```bash
   ssh root@192.168.1.X
   journalctl -u crafty-controller -f
   ```

### Crafty démarre mais l'interface n'est pas accessible

1. Vérifie que le conteneur fonctionne :
   ```bash
   ssh root@192.168.1.X
   docker ps | grep crafty
   ```

2. Consulte les logs du conteneur :
   ```bash
   docker logs crafty-controller
   ```

3. Vérifie la connectivité réseau :
   ```bash
   ping 192.168.1.X
   curl http://192.168.1.X:8000
   ```

### Besoin de déinstaller

```bash
# Via SSH
ssh root@192.168.1.X
fnnas uninstall crafty-controller

# Ou via l'App Center
# Centre d'applications → Crafty Controller → Désinstaller
```

---

## Support et documentation

- **Documentation Crafty** : https://docs.craftycontroller.io/
- **Documentation Fygo OS** : https://developer.fnnas.com/
- **fnpack docs** : https://developer.fnnas.com/docs/cli/fnpack/

---

## Notes importantes

### Sécurité

⚠️ **ATTENTION** : Ce paquet donne au conteneur Crafty un accès direct à `docker.sock`. Cela signifie que Crafty a un contrôle très élevé sur ton NAS.

- **Ne publie pas** l'interface Crafty directement sur Internet
- **Utilise un firewall** ou un reverse proxy sécurisé
- **Change les credentials par défaut** dès la première connexion
- **Mets à jour régulièrement** le paquet

### Stockage des données

Les données Crafty sont stockées dans :

```
/var/lib/fnos/apps/crafty-controller/
├── backups/      # Sauvegardes des serveurs
├── logs/         # Logs Crafty
├── servers/      # Dossiers des serveurs Minecraft
├── config/       # Configuration de Crafty
└── import/       # Imports de serveurs existants
```

Assure-toi d'avoir **au minimum 10 Go d'espace libre**.

### Performance

Avec ton Intel Pentium à 2 cœurs :

- Un seul **petit serveur Minecraft** (2-4 joueurs) : ✅ OK
- Plusieurs serveurs légers : ⚠️ Limité
- Un gros serveur (20+ joueurs) : ❌ Non recommandé

Considère une **mise à niveau du matériel** si tu veux héberger plusieurs serveurs actifs.

---

## Mises à jour futures

Pour mettre à jour Crafty Controller :

1. Recompile le paquet FPK (si une nouvelle version sort)
2. Via l'App Center : **Mettre à jour** (si disponible)
3. Ou réinstalle manuellement avec la nouvelle version

---

**Bon jeu !** 🎮

*Dernier build : 2026-10-01*
