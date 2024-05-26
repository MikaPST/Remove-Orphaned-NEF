# 📸 Remove-Orphaned-NEF.ps1

## Description
`Remove-Orphaned-NEF.ps1` est un script PowerShell conçu pour comparer les fichiers `.nef` (RAW) avec leurs versions `.jpg` correspondantes dans un dossier spécifique. Il supprime les fichiers `.nef` pour lesquels aucune version `.jpg` correspondante n'existe, afin de libérer de l'espace disque. Un fichier de log est généré pour documenter les actions effectuées par le script.

## 🚀 Fonctionnalités
- 🔍 Compare les fichiers `.nef` et `.jpg` dans un dossier donné
- 🗑️ Supprime les fichiers `.nef` sans version `.jpg` correspondante
- 📄 Génère un fichier de log pour documenter les actions
- 📊 Affiche la progression de la comparaison


## 🛠️ Utilisation
1. Clonez le dépôt sur votre machine locale.
    ```bash
    git clone https://github.com/MikaPST/Remove-Orphaned-NEF.git
    cd Remove-Orphaned-NEF
    ```
2. Ouvrez le script `Remove-Orphaned-NEF.ps1` dans un éditeur de texte et définissez la variable `$dossier` avec le chemin du répertoire contenant vos fichiers `.nef` et `.jpg`.
    ```powershell
    $dossier = "C:/chemin/vers/dossier/contenant/JPGetNEF"
    ```
3. Exécutez le script dans PowerShell.
    ```powershell
    ./Remove-Orphaned-NEF.ps1
    ```
4. Consultez le fichier de log généré pour les détails des actions effectuées.


## 📝 Licence

Ce projet est distribué sous la licence Apache 2.0. Vous pouvez en savoir plus sur cette licence à l'adresse suivante : [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).


## 📧 Contact

Pour toute question ou suggestion, n'hésitez pas à me contacter à [contact@michael-pastor.com](mailto:contact@michael-pastor.com).
