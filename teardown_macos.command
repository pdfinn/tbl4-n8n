#!/usr/bin/env bash
set -euo pipefail

# ─── Tarkas Brainlab IV — n8n Teardown (macOS) ─────────────────────────────
# Safely removes the n8n stack. Asks before each step.
# Nothing is deleted without your confirmation.

# Double-clicking a .command file launches it from the user's home dir,
# so jump to the script's own directory before doing anything.
cd "$(dirname "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[OK]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[!!]${NC}  $1"; }
skip()  { echo -e "${YELLOW}[--]${NC}  Skipped: $1"; }

confirm() {
    echo ""
    echo -e "${YELLOW}$1${NC}"
    read -r -p "Proceed? (y/N): " answer
    case "$answer" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

echo ""
echo "========================================="
echo "  Tarkas Brainlab IV — n8n Teardown"
echo "========================================="
echo ""
echo "This script will walk you through removing"
echo "the n8n stack. You will be asked before"
echo "anything is deleted."
echo ""

# ─── Step 1: Stop and remove n8n container ─────────────────────────────────
if docker ps -a --filter name=n8n --format '{{.Names}}' 2>/dev/null | grep -q '^n8n$'; then
    if confirm "Stop and remove the n8n container?"; then
        docker compose down
        info "n8n container removed"
    else
        skip "n8n container"
    fi
else
    info "n8n container is not running (nothing to do)"
fi

# ─── Step 2: Remove n8n Docker volume (workflows and credentials) ──────────
VOLUME_NAME=$(docker volume ls --filter name=n8n_data -q 2>/dev/null | grep 'n8n_data$' || true)
if [ -n "$VOLUME_NAME" ]; then
    if confirm "Remove n8n data volume? (This deletes all your workflows and credentials.)"; then
        docker volume rm "$VOLUME_NAME"
        info "n8n data volume removed"
    else
        skip "n8n data volume (workflows preserved)"
    fi
else
    info "No n8n data volume found (nothing to do)"
fi

# ─── Step 3: Remove n8n Docker image ───────────────────────────────────────
IMAGE_ID=$(docker images n8nio/n8n -q 2>/dev/null || true)
if [ -n "$IMAGE_ID" ]; then
    if confirm "Remove the n8n Docker image? (Frees ~600MB of disk space.)"; then
        docker rmi n8nio/n8n:latest
        info "n8n Docker image removed"
    else
        skip "n8n Docker image"
    fi
else
    info "No n8n Docker image found (nothing to do)"
fi

# ─── Done ────────────────────────────────────────────────────────────────────
echo ""
echo "========================================="
echo "  Teardown complete."
echo ""
echo "  This script only removes n8n."
echo "  Your Ollama and Open WebUI setup"
echo "  (from tbl4-local-llm) is not affected."
echo "========================================="
echo ""
