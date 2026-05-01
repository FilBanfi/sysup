#!/usr/bin/env bash

APP_NAME="sysup"
VERSION="0.1"

CONFIG_FILE="plugin.conf"
MODULES_DIR="modules"
LOCK_FILE="/tmp/sysup.lock"

echo "======================================"
echo "           SYSUP - $VERSION"
echo "   Universal Linux System Updater"
echo "======================================"
echo ""

if [[ -f "$LOCK_FILE" ]]; then
    echo "[ERROR] sysup is already running."
    exit 1
fi

touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

while true; do
    read -rp "Continue system update? [y/n]: " ans
    case "$ans" in
        y|Y) break ;;
        n|N) echo "Aborted."; exit 0 ;;
        *) echo "Please answer y or n." ;;
    esac
done

echo ""
echo "[SYSUP] Starting update..."
echo ""

while IFS='=' read -r path flag; do

    # skip empty lines
    [[ -z "$path" ]] && continue

    # skip comments
    [[ "$path" =~ ^# ]] && continue

    # skip disabled modules
    [[ "$flag" != "1" ]] && continue

    FILE="$MODULES_DIR/$path"

    echo "--------------------------------------"

    if [[ -f "$FILE" ]]; then
        echo "[RUN] $path"

        if bash "$FILE"; then
            echo "[OK] $path"
        else
            echo "[FAIL] $path"
        fi
    else
        echo "[WARN] module not found: $path"
    fi

    echo ""

done < "$CONFIG_FILE"

echo "======================================"
echo "      SYSTEM UPDATE COMPLETED"
echo "======================================"

exit 0
