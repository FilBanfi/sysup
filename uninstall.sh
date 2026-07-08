#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="0.1.0"

INSTALL_DIR="$HOME/.local/share/sysup"
BIN_DIR="$HOME/.local/bin"
SYMLINK="$BIN_DIR/sysup"

# ===== HEADER =====
echo -e "${GREEN}======================================"
echo -e "       SYSUP UNINSTALLER v$VERSION"
echo -e "   Universal Linux System Updater"
echo -e "           by FilBanfi"
echo -e "======================================${RESET}"
echo ""

# ===== CONFIRM =====
while true; do
    read -rp "Remove sysup from this system? [y/n]: " ans
    case "$ans" in
        y|Y) break ;;
        n|N)
            echo "Aborted."
            exit 0
            ;;
        *)
            echo "Please answer y or n."
            ;;
    esac
done

echo ""
echo -e "${YELLOW}[SYSUP] Starting uninstallation...${RESET}"
echo ""

# ===== REMOVE FILES =====
if [[ -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}[REMOVE] Deleting files...${RESET}"
    rm -rf "$INSTALL_DIR"
else
    echo -e "${RED}[WARN] install directory not found${RESET}"
fi

# ===== REMOVE SYMLINK =====
if [[ -L "$SYMLINK" ]]; then
    echo -e "${YELLOW}[REMOVE] Removing command 'sysup'...${RESET}"
    rm -f "$SYMLINK"
else
    echo -e "${RED}[WARN] symlink not found${RESET}"
fi

echo ""

# ===== FOOTER =====
echo -e "${GREEN}======================================"
echo -e "      UNINSTALL COMPLETED"
echo -e "======================================${RESET}"
