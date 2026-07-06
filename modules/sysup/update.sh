#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="0.2.0"
MODULE_NAME="MODULE_NAME"
DEVELOPER="FilBanfi"

# ===== HEADER =====
echo -e "${YELLOW}======================================"
echo -e "      $MODULE_NAME MODULE v$VERSION"
echo -e "           by $DEVELOPER"
echo -e "======================================${RESET}"

echo -e "${YELLOW}[$MODULE_NAME] Starting update...${RESET}"
echo ""

# ===== COMMANDS =====

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT_DIR" || exit 1

if [[ ! -d ".git" ]]; then
    echo -e "${RED}[$MODULE_NAME] ERROR: not a git repository${RESET}"
    exit 1
fi

if [[ ! -f "plugin.conf" ]]; then
    echo -e "${YELLOW}[$MODULE_NAME] plugin.conf not found, creating from template...${RESET}"
    cp plugin.conf.example plugin.conf
fi

git pull

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
