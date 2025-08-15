set -euo pipefail
PRIVATE_REPO_SSH="git@github.com:alinios/homelab-main.git"

# Detect the real user if running with sudo
if [ -n "${SUDO_USER-}" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

CLONE_DIR="${USER_HOME}/homelab"

echo "[bootstrap] cloning private repo (ssh) -> ${CLONE_DIR}"
if [ -d "${CLONE_DIR}" ]; then
    echo "[bootstrap] ${CLONE_DIR} already exists. Removing for fresh clone..."
    rm -rf "${CLONE_DIR}"
fi
git clone "${PRIVATE_REPO_SSH}" "${CLONE_DIR}"


echo "[bootstrap] Done. Now ssh into your server and run:"
