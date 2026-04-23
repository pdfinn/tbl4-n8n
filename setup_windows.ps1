# ─── TBL4 n8n Setup (Windows) ───────────────────────────────────────────────
# This script starts n8n with Docker. It assumes you already have Docker
# Desktop installed (from the tbl4-local-llm setup).
# It is safe to run multiple times.
#
# Students: just double-click setup_windows.bat in File Explorer.
# This file is the internal script the wrapper calls.

$ErrorActionPreference = "Stop"

function Info($msg)  { Write-Host "[OK]  $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "[!!]  $msg" -ForegroundColor Yellow }
function Fail($msg)  { Write-Host "[ERR] $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "========================================="
Write-Host "  Tarkas Brainlab IV — n8n Setup"
Write-Host "========================================="
Write-Host ""

# ─── Load config ─────────────────────────────────────────────────────────────
if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Info "Created .env from .env.example"
}

$envVars = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
        $envVars[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$N8nPort = if ($envVars["N8N_PORT"]) { $envVars["N8N_PORT"] } else { "5678" }

# ─── Check: Docker ───────────────────────────────────────────────────────────
try {
    $null = Get-Command docker -ErrorAction Stop
} catch {
    Fail "Docker is not installed. Please install Docker Desktop first:`nhttps://www.docker.com/products/docker-desktop/`n`nIf you already ran the tbl4-local-llm setup, Docker should be installed.`nMake sure Docker Desktop is open and running."
}

try {
    $null = docker info 2>&1
} catch {
    Fail "Docker is not running. Please start Docker Desktop and try again."
}
Info "Docker is running"

# ─── Check: Ollama (optional, for AI workflows) ─────────────────────────────
$ollamaRunning = $false
try {
    $null = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 2
    $ollamaRunning = $true
} catch {}

if ($ollamaRunning) {
    Info "Ollama is running (you can use it in n8n AI workflows)"
} else {
    Warn "Ollama is not running. n8n will work fine, but AI nodes"
    Write-Host "       that use Ollama won't connect until you start it."
}

# ─── Start n8n ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Starting n8n..."
& docker compose up -d
Info "n8n is running"

# ─── Wait for n8n to be ready ────────────────────────────────────────────────
Write-Host ""
Write-Host "Waiting for n8n to start up..."
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 2
    try {
        $null = Invoke-RestMethod -Uri "http://localhost:$N8nPort/healthz" -TimeoutSec 2
        $ready = $true
        break
    } catch {}
}

if ($ready) {
    Info "n8n is ready"
} else {
    Warn "n8n is still starting up - give it another minute, then check the URL below"
}

# ─── Done ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================="
Write-Host "  Setup complete!"
Write-Host ""
Write-Host "  Open your browser to:"
Write-Host "  http://localhost:$N8nPort"
Write-Host ""
Write-Host "  On first launch you will create an"
Write-Host "  owner account (just pick any email"
Write-Host "  and password - it is local only)."
Write-Host ""
Write-Host "  Next time, just double-click setup_windows.bat"
Write-Host "  again. It is safe to re-run any time."
Write-Host ""
Write-Host "  Advanced (from the command line):"
Write-Host "    Stop:  docker compose down"
Write-Host "    Start: docker compose up -d"
Write-Host "========================================="
Write-Host ""
