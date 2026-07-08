#!/usr/bin/env bash

# ===== COLORS =====
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

APP_NAME="sysup"
VERSION="0.1.0"

CONFIG_FILE="plugin.conf"
MODULES_DIR="modules"
LOCK_FILE="/tmp/sysup.lock"

# ===== HEADER =====
echo -e "${GREEN}======================================"
echo -e "           SYSUP v$VERSION"
echo -e "   Universal Linux System Updater"
echo -e "           by FilBanfi"
echo -e "======================================${RESET}"
echo ""

# ===== LOCK =====
if [[ -f "$LOCK_FILE" ]]; then
    OLD_PID=$(cat "$LOCK_FILE")

    # check se il processo esiste ancora
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo -e "${RED}[ERROR] sysup is already running.${RESET}"
        exit 1
    else
        # processo morto ma lock rimasto (stale lock)
        echo -e "${YELLOW}[WARN] removing stale lock.${RESET}"
        rm -f "$LOCK_FILE"
    fi
fi

# crea nuovo lock con PID corrente
echo "$$" > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# ===== CONFIRM =====
while true; do
    read -rp "Continue system update? [y/n]: " ans
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
echo -e "${YELLOW}[SYSUP] Starting update...${RESET}"
echo ""

# ===== RUN MODULES =====
while IFS='=' read -r path flag; do

    # skip empty lines
    [[ -z "$path" ]] && continue

    # skip comments
    [[ "$path" =~ ^# ]] && continue

    # trim whitespace
    path="${path// /}"
    flag="${flag// /}"

    # skip disabled modules
    [[ "$flag" != "1" ]] && continue

    FILE="$MODULES_DIR/$path"

    echo -e "${YELLOW}======================================${RESET}"
    if [[ -f "$FILE" ]]; then
        echo -e "${YELLOW}[RUN] $path${RESET}"
    
        if bash "$FILE"; then
            echo -e "${GREEN}[OK] $path${RESET}"
        else
            echo -e "${RED}[FAIL] $path${RESET}"
        fi
    else
        echo -e "${RED}[WARN] module not found: $path${RESET}"
    fi

    echo ""

done < "$CONFIG_FILE"

# ===== FOOTER =====
echo -e "${GREEN}======================================"
echo -e "      SYSTEM UPDATE COMPLETED"
echo -e "======================================${RESET}"

exit 0
