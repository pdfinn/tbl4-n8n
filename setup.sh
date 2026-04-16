#!/usr/bin/env bash
set -euo pipefail

# ─── TBL4 n8n Setup (macOS) ────────────────────────────────────────────────
# This script starts n8n with Docker. It assumes you already have Docker
# Desktop installed (from the tbl4-local-llm setup).
# It is safe to run multiple times.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[OK]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[!!]${NC}  $1"; }
fail()  { echo -e "${RED}[ERR]${NC} $1"; exit 1; }

echo ""
echo "========================================="
echo "  Tarkas Brainlab IV — n8n Setup"
echo "========================================="
echo ""

# ─── Load config ─────────────────────────────────────────────────────────────
if [ ! -f .env ]; then
    cp .env.example .env
    info "Created .env from .env.example"
fi
source .env

N8N_PORT="${N8N_PORT:-5678}"

# ─── Check: Docker ───────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    fail "Docker is not installed. Please install Docker Desktop first:
    https://www.docker.com/products/docker-desktop/

    If you already ran the tbl4-local-llm setup, Docker should be installed.
    Make sure Docker Desktop is open and running."
fi

if ! docker info &>/dev/null; then
    fail "Docker is not running. Please start Docker Desktop and try again."
fi
info "Docker is running"

# ─── Check: Ollama (optional, for AI workflows) ─────────────────────────────
if curl -sf http://localhost:11434/api/tags &>/dev/null; then
    info "Ollama is running (you can use it in n8n AI workflows)"
else
    warn "Ollama is not running. n8n will work fine, but AI nodes"
    echo "       that use Ollama won't connect until you start it:"
    echo "       ollama serve"
fi

# ─── Start n8n ───────────────────────────────────────────────────────────────
echo ""
echo "Starting n8n..."
docker compose up -d
info "n8n is running"

# ─── Wait for n8n to be ready ────────────────────────────────────────────────
echo ""
echo "Waiting for n8n to start up..."
for i in {1..30}; do
    if curl -sf "http://localhost:${N8N_PORT}/healthz" &>/dev/null; then
        break
    fi
    sleep 2
done

if curl -sf "http://localhost:${N8N_PORT}/healthz" &>/dev/null; then
    info "n8n is ready"
else
    warn "n8n is still starting up — give it another minute, then check the URL below"
fi

# ─── Done ────────────────────────────────────────────────────────────────────
echo ""
echo "========================================="
echo "  Setup complete!"
echo ""
echo "  Open your browser to:"
echo "  http://localhost:${N8N_PORT}"
echo ""
echo "  On first launch you will create an"
echo "  owner account (just pick any email"
echo "  and password — it is local only)."
echo ""
echo "  To stop n8n:"
echo "    docker compose down"
echo ""
echo "  To start again later:"
echo "    docker compose up -d"
echo "========================================="
echo ""
