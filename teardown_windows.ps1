# --- Tarkas Brainlab IV - n8n Teardown (Windows) ----------------------------
# Safely removes the n8n stack. Asks before each step.
# Nothing is deleted without your confirmation.
#
# Students: just double-click teardown_windows.bat in File Explorer.
# This file is the internal script the wrapper calls.
#
# Note: this file is intentionally pure ASCII (no BOM, no Unicode box-drawing
# characters, no em-dashes) for maximum encoding safety on Windows.

$ErrorActionPreference = "Stop"

function Info($msg)  { Write-Host "[OK]  $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "[!!]  $msg" -ForegroundColor Yellow }
function Skip($msg)  { Write-Host "[--]  Skipped: $msg" -ForegroundColor Yellow }

function Confirm-Step($message) {
    Write-Host ""
    Write-Host $message -ForegroundColor Yellow
    $answer = Read-Host "Proceed? (y/N)"
    return ($answer -eq "y" -or $answer -eq "Y" -or $answer -eq "yes")
}

Write-Host ""
Write-Host "========================================="
Write-Host "  Tarkas Brainlab IV - n8n Teardown"
Write-Host "========================================="
Write-Host ""
Write-Host "This script will walk you through removing"
Write-Host "the n8n stack. You will be asked before"
Write-Host "anything is deleted."
Write-Host ""

# --- Step 1: Stop and remove n8n container ----------------------------------
$container = docker ps -a --filter name=n8n --format '{{.Names}}' 2>$null
if ($container -eq "n8n") {
    if (Confirm-Step "Stop and remove the n8n container?") {
        docker compose down
        Info "n8n container removed"
    } else {
        Skip "n8n container"
    }
} else {
    Info "n8n container is not running (nothing to do)"
}

# --- Step 2: Remove n8n Docker volume (workflows and credentials) -----------
$volume = docker volume ls --filter name=n8n_data -q 2>$null | Where-Object { $_ -match 'n8n_data$' }
if ($volume) {
    if (Confirm-Step "Remove n8n data volume? (This deletes all your workflows and credentials.)") {
        docker volume rm $volume
        Info "n8n data volume removed"
    } else {
        Skip "n8n data volume (workflows preserved)"
    }
} else {
    Info "No n8n data volume found (nothing to do)"
}

# --- Step 3: Remove n8n Docker image ----------------------------------------
$image = docker images docker.n8n.io/n8nio/n8n -q 2>$null
if ($image) {
    if (Confirm-Step "Remove the n8n Docker image? (Frees ~600MB of disk space.)") {
        docker rmi docker.n8n.io/n8nio/n8n:latest
        Info "n8n Docker image removed"
    } else {
        Skip "n8n Docker image"
    }
} else {
    Info "No n8n Docker image found (nothing to do)"
}

# --- Done -------------------------------------------------------------------
Write-Host ""
Write-Host "========================================="
Write-Host "  Teardown complete."
Write-Host ""
Write-Host "  This script only removes n8n."
Write-Host "  Your Ollama and Open WebUI setup"
Write-Host "  (from tbl4-local-llm) is not affected."
Write-Host "========================================="
Write-Host ""
Read-Host "Press Enter to close this window"
