#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="1.0"
MODULE_NAME="SYSUP"

# ===== HEADER =====
echo -e "${YELLOW}======================================"
echo -e "      $MODULE_NAME MODULE v$VERSION"
echo -e "           by FilBanfi"
echo -e "======================================${RESET}"

echo -e "${YELLOW}[$MODULE_NAME] Starting update...${RESET}"
echo ""

# ===== COMMANDS =====

SYSUP_DIR="$HOME/.local/share/sysup"

echo -e "${YELLOW}[SYSUP] Updating repository...${RESET}"

cd "$SYSUP_DIR" || exit 1

git pull

GIT_STATUS=$?

echo ""

# ===== RESULT =====
if [[ $GIT_STATUS -eq 0 ]]; then
    echo -e "${GREEN}[SYSUP] Repository updated${RESET}"

    # create plugin.conf if missing
    if [[ ! -f "plugin.conf" ]]; then
        echo -e "${YELLOW}[SYSUP] Creating plugin.conf...${RESET}"

        cp "plugin.conf.example" "plugin.conf"

        echo -e "${GREEN}[SYSUP] plugin.conf created${RESET}"
    fi

    # notify user about new modules/config changes
    echo ""
    echo -e "${YELLOW}[INFO] Check plugin.conf.example for new official modules.${RESET}"

else
    echo -e "${RED}[SYSUP] ERROR: update failed${RESET}"
fi

COMMAND_HERE

# ===== RESULT =====
if [[ $? -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}[$MODULE_NAME] Update completed${RESET}"
else
    echo ""
    echo -e "${RED}[$MODULE_NAME] ERROR: update failed${RESET}"
fi

echo -e "${YELLOW}======================================${RESET}"
echo ""
