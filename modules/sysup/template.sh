#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

VERSION="0.2.0"
MODULE_NAME="MODULE_NAME"
DEVELOPER="DEVELOPER_NAME"

# ===== HEADER =====
echo -e "${YELLOW}======================================"
echo -e "      $MODULE_NAME MODULE v$VERSION"
echo -e "           by $DEVELOPER"
echo -e "======================================${RESET}"

echo -e "${YELLOW}[$MODULE_NAME] Starting update...${RESET}"
echo ""

# ===== COMMANDS =====

# insert commands here
# example:
# sudo dnf upgrade -y

# ===== CHECK =====

EXIT_CODE=$?

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
