# 📸 Remove-Orphaned-NEF.ps1

[🇬🇧 Read in English](README.md) | [🇫🇷 Lire en Français](README_FR.md)

Un script PowerShell pour les photographes qui souhaitent nettoyer les fichiers RAW orphelins après le tri de leurs photos.

## 🧭 Le problème qu'il résout

De nombreux photographes shootent en mode RAW+JPEG. Lors du tri, ils visionnent les JPEGs et suppriment les photos floues ou sans intérêt — mais les fichiers `.nef` correspondants restent sur le disque, gaspillant silencieusement de l'espace. Ce script détecte ces fichiers `.nef` orphelins et les supprime automatiquement.

## 🚀 Fonctionnalités

- 🔍 Compare les fichiers `.nef` avec leurs équivalents `.jpg` / `.jpeg` (insensible à la casse)
- 🧪 **Mode simulation** — prévisualiser l'opération avant toute suppression
- 🗂️ **Mode récursif** — analyser optionnellement les sous-dossiers
- 🗑️ Supprime les fichiers `.nef` orphelins, avec le flag `-Force` pour ignorer la confirmation
- 📄 Génère un fichier de log horodaté documentant chaque action
- 📊 Affiche une barre de progression en temps réel
- 🛡️ Gestion des erreurs — les fichiers verrouillés sont loggés et ignorés sans planter le script

## 🛠️ Utilisation

### 1. Cloner le dépôt

```bash
git clone https://github.com/MikaPST/Remove-Orphaned-NEF.git
cd Remove-Orphaned-NEF
```

### 2. Exécuter le script

Passez le chemin de votre dossier de photos via le paramètre `-Dossier` :

```powershell
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024"
```

### 3. Workflow recommandé

Lancez toujours une **simulation en premier** pour prévisualiser ce qui sera supprimé :

```powershell
# Simulation — aucun fichier ne sera supprimé
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -DryRun

# Suppression réelle
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024"

# Avec les sous-dossiers, sans confirmation
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -Recurse -Force
```

## ⚙️ Paramètres

| Paramètre | Type | Description |
|-----------|------|-------------|
| `-Dossier` | `string` | Chemin du dossier contenant vos fichiers `.nef` et `.jpg` |
| `-Recurse` | `switch` | Analyser également les sous-dossiers |
| `-DryRun` | `switch` | Simuler sans supprimer aucun fichier |
| `-Force` | `switch` | Ignorer les demandes de confirmation |

## 📋 Fichier de log

Un fichier de log horodaté est créé à côté du script après chaque exécution :

```
log_Remove-Orphaned-NEF_20260520-143022.txt
```

Il enregistre chaque fichier supprimé (avec sa taille), les éventuelles erreurs, et un résumé final.

## 📝 Licence

Distribué sous la [licence Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request.
