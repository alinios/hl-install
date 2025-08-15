#!/usr/bin/env bash
# homelab.sh
# A tiny public bootstrap that clones your private install repo (homelab).

set -euo pipefail

PRIVATE_REPO_SSH="git@github.com:alinios/homelab-main.git"
CLONE_DIR="${HOME}/homelab"

echo "[bootstrap] cloning private repo (ssh) -> ${CLONE_DIR}"
if [ -d "${CLONE_DIR}" ]; then
  echo "[bootstrap] ${CLONE_DIR} already exists. Pulling latest..."
  (cd "${CLONE_DIR}" && git pull)
else
  git clone "${PRIVATE_REPO_SSH}" "${CLONE_DIR}"
fi

echo "[bootstrap] Done. Now ssh into your server and run:"
echo "  cd ${CLONE_DIR} && sudo ./install.sh"
