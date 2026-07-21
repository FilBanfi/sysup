#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="0.3.0"

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

# ===== VERIFY INSTALLATION =====
if [[ ! -d "$INSTALL_DIR/modules" ]]; then
    echo -e "${RED}[ERROR] Installation failed: modules directory missing${RESET}"
    exit 1
fi

if [[ ! -f "$INSTALL_DIR/update.sh" ]]; then
    echo -e "${RED}[ERROR] Installation failed: update.sh missing${RESET}"
    exit 1
fi

# ===== CONFIG INIT =====
echo -e "${YELLOW}[CONF] Initializing configuration...${RESET}"

if [[ ! -f "$INSTALL_DIR/plugin.conf" ]]; then
    cp "$INSTALL_DIR/plugin.conf.example" "$INSTALL_DIR/plugin.conf"
    echo -e "${GREEN}[CONF] plugin.conf created${RESET}"
else
    echo -e "${YELLOW}[CONF] plugin.conf already exists (skipped)${RESET}"
fi

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

# ===== VERIFY INSTALLATION =====
if [[ ! -d "$INSTALL_DIR/modules" ]]; then
    echo -e "${RED}[ERROR] Installation failed: modules directory missing${RESET}"
    exit 1
fi

if [[ ! -f "$INSTALL_DIR/update.sh" ]]; then
    echo -e "${RED}[ERROR] Installation failed: update.sh missing${RESET}"
    exit 1
fi

# ===== CHECK PATH =====
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}[PATH] Configuring PATH for seamless usage...${RESET}"
    
    # Lista dei file di configurazione più comuni (copre il 99% degli utenti Linux)
    RC_FILES=("$HOME/.bashrc" "$HOME/.zshrc")
    ADDED=0
    
    for rc_file in "${RC_FILES[@]}"; do
        if [[ -f "$rc_file" ]]; then
            # Controlla se la riga esiste già per evitare duplicati
            if ! grep -q "export PATH=\"$BIN_DIR:\$PATH\"" "$rc_file" 2>/dev/null; then
                echo "" >> "$rc_file"
                echo "# Added by sysup installer" >> "$rc_file"
                echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$rc_file"
                echo -e "${GREEN}[PATH] Added to $(basename "$rc_file")${RESET}"
                ADDED=1
            fi
        fi
    done
    
    if [[ $ADDED -eq 0 ]]; then
        echo -e "${YELLOW}[WARN] No .bashrc or .zshrc found. Please add $BIN_DIR to your PATH manually.${RESET}"
    else
        # Applica il PATH alla sessione corrente immediatamente
        export PATH="$BIN_DIR:$PATH"
    fi
else
    echo -e "${GREEN}[PATH] $BIN_DIR is already in PATH${RESET}"
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
