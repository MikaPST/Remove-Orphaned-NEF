# -----------------------------------------------------------------------------
# Script Name: Remove-Orphaned-NEF.ps1
# Author: Michael PASTOR (MikaPST)
# Date: 20-May-2026
# Version: 2.0
# License: Apache 2.0
#
# Description:
# Ce script PowerShell compare les fichiers .nef (RAW) avec leurs versions
# .jpg/.jpeg correspondantes dans un dossier. Il supprime les fichiers .nef
# orphelins (sans JPEG associé) afin de libérer de l'espace disque.
# Un fichier de log horodaté documente chaque action effectuée.
#
# Paramètres:
#   -Dossier   Chemin du répertoire à analyser (obligatoire)
#   -Recurse   Parcourir également les sous-dossiers
#   -DryRun    Simuler sans supprimer aucun fichier
#   -Force     Supprimer sans demande de confirmation
#
# Exemples:
#   ./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024"
#   ./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -DryRun
#   ./Remove-Orphaned-NEF.ps1 -Dossier "D:/Photos/2024" -Recurse -Force
#
# Licence:
# Ce script est distribué sous la licence Apache 2.0.
# http://www.apache.org/licenses/LICENSE-2.0
# -----------------------------------------------------------------------------

[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $Dossier = "C:/chemin/vers/dossier/contenant/JPGetNEF",
    [switch] $Recurse,   # Parcourir les sous-dossiers
    [switch] $DryRun,    # Simuler sans supprimer
    [switch] $Force      # Pas de confirmation interactive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Fichier de log ────────────────────────────────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$dateHeure = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile   = Join-Path $scriptDir "log_Remove-Orphaned-NEF_$dateHeure.txt"

function Write-Log {
    param([string]$message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$ts - $message"
}

# ── Validation du dossier ─────────────────────────────────────────────────────
if (-not (Test-Path $Dossier -PathType Container)) {
    Write-Error "Dossier introuvable : $Dossier"
    exit 1
}

# ── En-tête ───────────────────────────────────────────────────────────────────
$mode = if ($DryRun) { "[DRY-RUN]" } else { "[RÉEL]" }
$modeColor = if ($DryRun) { 'Cyan' } else { 'Yellow' }
$modeMsg   = if ($DryRun) { "Simulation — aucun fichier ne sera supprimé." } `
                          else { "Les fichiers NEF orphelins seront supprimés." }

Write-Host "`n$mode $modeMsg" -ForegroundColor $modeColor
Write-Host "Dossier analysé : $Dossier"
Write-Host "Récursif        : $($Recurse.IsPresent)`n"

Write-Log "=== Début $mode ==="
Write-Log "Dossier : $Dossier | Récursif : $($Recurse.IsPresent)"

# ── Collecte des fichiers NEF ─────────────────────────────────────────────────
$getParams = @{
    Path    = $Dossier
    Filter  = '*.nef'
    Recurse = $Recurse.IsPresent
}
$fichiersNEF = Get-ChildItem @getParams

if ($fichiersNEF.Count -eq 0) {
    $msg = "Aucun fichier .NEF trouvé dans $Dossier."
    Write-Host $msg
    Write-Log $msg
    Write-Log "=== Fin ==="
    exit 0
}

Write-Host "$($fichiersNEF.Count) fichier(s) NEF trouvé(s). Analyse en cours...`n"

# ── Boucle principale ─────────────────────────────────────────────────────────
$espaceGagne = 0
$supprimes   = 0
$erreurs     = 0
$i           = 0

foreach ($nef in $fichiersNEF) {
    $i++
    Write-Progress -Activity "Analyse des fichiers NEF" `
                   -Status "$i / $($fichiersNEF.Count) — $($nef.Name)" `
                   -PercentComplete ([int]($i / $fichiersNEF.Count * 100))

    # Recherche insensible à la casse : .jpg, .JPG et .jpeg
    $dir      = $nef.DirectoryName
    $baseName = $nef.BaseName
    $jpgExiste = (Test-Path (Join-Path $dir "$baseName.jpg"))  -or
                 (Test-Path (Join-Path $dir "$baseName.JPG"))  -or
                 (Test-Path (Join-Path $dir "$baseName.jpeg")) -or
                 (Test-Path (Join-Path $dir "$baseName.JPEG"))

    if (-not $jpgExiste) {
        $tailleNef = $nef.Length
        $espaceGagne += $tailleNef
        $supprimes++

        if ($DryRun) {
            Write-Log "DRY-RUN   : $($nef.FullName) ($([math]::Round($tailleNef / 1MB, 2)) Mo) — aurait été supprimé."
        }
        else {
            try {
                Remove-Item $nef.FullName -Force
                Write-Log "SUPPRIMÉ  : $($nef.FullName) ($([math]::Round($tailleNef / 1MB, 2)) Mo)"
            }
            catch {
                $erreurs++
                $supprimes--
                $espaceGagne -= $tailleNef
                Write-Log "ERREUR    : $($nef.FullName) — $_"
                Write-Warning "Impossible de supprimer : $($nef.Name)"
            }
        }
    }
}

Write-Progress -Activity "Analyse des fichiers NEF" -Completed

# ── Résumé ────────────────────────────────────────────────────────────────────
$espMo   = [math]::Round($espaceGagne / 1MB, 2)
$action  = if ($DryRun) { "seraient supprimés" } else { "supprimés" }

$summary = @"

=== Résumé $mode ===
  NEF analysés         : $($fichiersNEF.Count)
  NEF $action          : $supprimes
  Espace libéré        : $espMo Mo
  Erreurs de suppression : $erreurs
  Log                  : $logFile
"@

Write-Host $summary
Write-Log $summary
Write-Log "=== Fin ==="
