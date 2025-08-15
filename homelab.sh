#!/usr/bin/env bash
# homelab.sh
# Bootstrap script to clone private install repo (homelab) using HTTPS + token.

set -euo pipefail

# === CONFIG ===
# GitHub HTTPS URL without credentials
PRIVATE_REPO_HTTPS="https://github.com/alinios/homelab-main.git"
# GitHub personal access token (read-only is enough for private repo)
# Example: "ghp_xxx..." 
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

# Detect the real user if running with sudo
if [ -n "${SUDO_USER-}" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

CLONE_DIR="${USER_HOME}/homelab"

# === Check GitHub token ===
if [ -z "$GITHUB_TOKEN" ]; then
    echo "[error] GITHUB_TOKEN not set. Export it first:"
    echo "  export GITHUB_TOKEN='your_token_here'"
    exit 1
fi

# Build the HTTPS URL with token
REPO_URL="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/alinios/homelab-main.git"

# === Clone or rewrite ===
if [ -d "${CLONE_DIR}" ]; then
    echo "[bootstrap] ${CLONE_DIR} already exists. Removing it for fresh clone..."
    rm -rf "${CLONE_DIR}"
fi

echo "[bootstrap] cloning private repo (HTTPS) -> ${CLONE_DIR}"
git clone "${REPO_URL}" "${CLONE_DIR}"

# Fix ownership if run via sudo
if [ -n "${SUDO_USER-}" ]; then
    chown -R "$SUDO_USER":"$SUDO_USER" "${CLONE_DIR}"
fi

echo "[bootstrap] Done. Now run:"
echo "  cd ${CLONE_DIR} && sudo ./install.sh"
