# 📸 Remove-Orphaned-NEF.ps1

[🇬🇧 Read in English](README.md) | [🇫🇷 Lire en Français](README_FR.md)

A PowerShell script for photographers who want to clean up orphaned RAW files after culling their shots.

## 🧭 The problem it solves

Many photographers shoot in RAW+JPEG mode. When culling, they review the JPEGs and delete the ones that are blurry or uninteresting — but the corresponding `.nef` RAW files remain on disk, silently wasting space. This script detects those orphaned `.nef` files and removes them automatically.

## 🚀 Features

- 🔍 Compares `.nef` files against their `.jpg` / `.jpeg` counterparts (case-insensitive)
- 🧪 **Dry-run mode** — simulate the operation before deleting anything
- 🗂️ **Recursive mode** — optionally scan sub-folders
- 🗑️ Deletes orphaned `.nef` files with optional `-Force` flag to skip confirmation
- 📄 Generates a timestamped log file documenting every action
- 📊 Displays a real-time progress bar
- 🛡️ Graceful error handling — locked files are logged and skipped without crashing

## 🛠️ Usage

### 1. Clone the repository

```bash
git clone https://github.com/MikaPST/Remove-Orphaned-NEF.git
cd Remove-Orphaned-NEF
```

### 2. Run the script

Pass the path to your photo folder via the `-Dossier` parameter:

```powershell
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024"
```

### 3. Recommended workflow

Always run a **dry-run first** to preview what would be deleted:

```powershell
# Simulate — nothing will be deleted
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -DryRun

# Delete for real
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024"

# Include sub-folders, skip confirmation
./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -Recurse -Force
```

## ⚙️ Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `-Dossier` | `string` | Path to the folder containing your `.nef` and `.jpg` files |
| `-Recurse` | `switch` | Also scan sub-folders |
| `-DryRun` | `switch` | Simulate without deleting any file |
| `-Force` | `switch` | Skip confirmation prompts |

## 📋 Log file

A timestamped log file is created next to the script after each run:

```
log_Remove-Orphaned-NEF_20260520-143022.txt
```

It records every deleted file (with its size), any errors encountered, and a final summary.

## 📝 License

Distributed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## 📧 Contact

Questions or suggestions? Feel free to reach out at [contact@michael-pastor.com](mailto:contact@michael-pastor.com).
