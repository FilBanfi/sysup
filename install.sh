#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="1.0"

INSTALL_DIR="$HOME/.local/share/sysup"
BIN_DIR="$HOME/.local/bin"

# ===== HEADER =====
echo -e "${GREEN}======================================"
echo -e "        SYSUP INSTALLER v$VERSION"
echo -e "   Universal Linux System Updater"
echo -e "           by FilBanfi"
echo -e "======================================${RESET}"
echo ""

# ===== START =====
echo -e "${YELLOW}[SYSUP] Starting installation...${RESET}"
echo ""

# ===== CREATE DIRS =====
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# ===== COPY FILES =====
echo -e "${YELLOW}[COPY] Installing files...${RESET}"
cp -r ./* "$INSTALL_DIR"

# ===== PERMISSIONS =====
echo -e "${YELLOW}[PERM] Setting executable permissions...${RESET}"

chmod +x "$INSTALL_DIR/update.sh"
chmod +x "$INSTALL_DIR/uninstall.sh"

find "$INSTALL_DIR/modules" \
    -type f \
    -name "*.sh" \
    -exec chmod +x {} +

# ===== SYMLINKS =====
echo -e "${YELLOW}[LINK] Creating commands...${RESET}"

ln -sf "$INSTALL_DIR/update.sh" "$BIN_DIR/sysup"
ln -sf "$INSTALL_DIR/uninstall.sh" "$BIN_DIR/sysup-remove"

# ===== CHECK PATH =====
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}[WARN] $BIN_DIR not in PATH${RESET}"
    echo "Add it with:"
    echo "export PATH=\"$BIN_DIR:\$PATH\""
fi

echo ""

# ===== FOOTER =====
echo -e "${GREEN}======================================"
echo -e "       INSTALLATION COMPLETED"
echo -e "======================================${RESET}"
echo ""

echo "Commands:"
echo "  sysup"
echo "  sysup-remove"
