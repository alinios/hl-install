#!/usr/bin/env bash
set -euo pipefail

PRIVATE_REPO_SSH="git@github.com:alinios/homelab-main.git"

# Detect the real user if running with sudo
if [ -n "${SUDO_USER-}" ]; then
    REAL_USER="${SUDO_USER}"
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    REAL_USER="$(whoami)"
    USER_HOME="$HOME"
fi

CLONE_DIR="${USER_HOME}/homelab"
TMP_DIR="${USER_HOME}/homelab_tmp"

echo "[bootstrap] Updating private repo -> ${CLONE_DIR}"

# Remove old temporary folder if exists
rm -rf "${TMP_DIR}"

# Clone fresh into temporary folder
git clone "${PRIVATE_REPO_SSH}" "${TMP_DIR}"

# Sync files to actual folder (overwrite/update files from repo,
# add new files, leave container-generated files intact)
rsync -av --exclude '.git' "${TMP_DIR}/" "${CLONE_DIR}/"

# Remove temporary clone
rm -rf "${TMP_DIR}"

# Ensure install.sh is executable
chmod +x "${CLONE_DIR}/install.sh"

echo "[bootstrap] Running install.sh now..."
# Run install.sh as sudo
sudo "${CLONE_DIR}/install.sh"

echo "[bootstrap] Done."
