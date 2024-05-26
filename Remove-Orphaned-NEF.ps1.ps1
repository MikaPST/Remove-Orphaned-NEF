# -----------------------------------------------------------------------------
# Script Name: Remove-Orphaned-NEF.ps1
# Author: Michael PASTOR (MikaPST)
# Date: 26-May-2024
# Version: 1.0
# License: Apache 2.0
#
# Description:
# Ce script PowerShell a été conçu pour comparer les fichiers .nef (RAW) avec 
# leurs versions .jpg correspondantes dans un dossier spécifique. Il permet de 
# supprimer les fichiers .nef pour lesquels aucune version .jpg correspondante 
# n'existe, afin de libérer de l'espace disque. Un fichier de log est généré pour 
# documenter les actions effectuées par le script.
#
# Utilisation:
# Ce script peut être exécuté sans paramètres spécifiques. Il suffit de définir 
# la variable `$dossier` avec le chemin du répertoire contenant les fichiers .nef 
# et .jpg.
#
# Exemple:
# ./Remove-Orphaned-NEF.ps1
#
# Licence:
# Ce script est distribué sous la licence Apache 2.0. Vous pouvez en savoir 
# plus sur cette licence à l'adresse suivante : 
# http://www.apache.org/licenses/LICENSE-2.0
#
# -----------------------------------------------------------------------------

# Chemin du dossier contenant les fichiers
$dossier = "C:/chemin/vers/dossier/contenant/JPGetNEF"

# Obtenir le chemin du répertoire où se trouve le script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Obtenir la date et l'heure actuelle pour inclure dans le nom du fichier de log
$dateHeure = Get-Date -Format "yyyyMMdd-HHmmss"

# Chemin du fichier de log avec la date et l'heure actuelle dans son nom
$logFile = Join-Path -Path $scriptDirectory -ChildPath "log_Remove-Orphaned-NEF_$dateHeure.txt"

# Fonction pour écrire dans le fichier de log
function Write-Log {
    param(
        [string]$message
    )
    $logTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$logTimestamp - $message"
    Add-content -Path $logFile -Value $logMessage
}

# Log de début de comparaison
Write-Log "Début de la comparaison des fichiers dans le dossier $dossier"

# Récupérer tous les fichiers .nef
$fichiersNEF = Get-ChildItem -Path $dossier -Filter "*.nef"

# Initialiser la variable pour stocker l'espace gagné
$espaceGagne = 0

# Initialiser la variable pour le compteur de progression
$progression = 0

# Parcourir chaque fichier .nef
foreach ($nef in $fichiersNEF) {
    # Construire le chemin du fichier .jpg correspondant
    $jpg = [System.IO.Path]::ChangeExtension($nef.FullName, ".jpg")
    
    # Vérifier si le fichier .jpg existe
    if (-not (Test-Path $jpg)) {
        # Ajouter la taille du fichier .nef à l'espace gagné
        $espaceGagne += $nef.Length
        
        # Supprimer le fichier .nef s'il n'y a pas de version .jpg correspondante
        Remove-Item $nef.FullName -Force
        Write-Log "Fichier $nef supprimé car la version .jpg correspondante est manquante."
    }
    
    # Mettre à jour la progression
    $progression++
    $pourcentage = ($progression / $fichiersNEF.Count) * 100
    Write-Progress -Activity "Comparaison des fichiers" -Status "Progression : $pourcentage %" -PercentComplete $pourcentage
}

# Convertir la taille de l'espace gagné en mégaoctets
$espaceGagneMo = $espaceGagne / 1MB

# Log de l'espace gagné
Write-Log "Espace gagné: $espaceGagneMo Mo"

# Log de fin de comparaison
Write-Log "Fin de la comparaison des fichiers."

Write-Host "Comparaison terminée. Les détails sont enregistrés dans $logFile."
