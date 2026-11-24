#!/bin/bash
# run-view-v2.sh — Auto-View V2 (USB + uiautomator2) — Interaktif

set -e

# Warna
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=========================================="
echo -e "   AUTO-VIEW V2 (USB) — Interaktif"
echo -e "==========================================${NC}"
echo ""

# Cek ADB
if ! adb devices | grep -q "device"; then
    echo -e "${RED}❌ HP tidak terdeteksi. Cek USB + ADB.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ HP terdeteksi.${NC}"
echo ""

# Tanya URL
while true; do
    read -p "Paste URL TikTok: " TARGET_URL
    [ -n "$TARGET_URL" ] && break
    echo -e "${RED}❌ URL tidak boleh kosong.${NC}"
done

# Tanya siklus
read -p "Berapa siklus? (default 1): " SIKLUS
[ -z "$SIKLUS" ] && SIKLUS=1

echo ""
echo -e "${CYAN}=== START AUTO-VIEW V2 ===${NC}"
echo -e "URL    : ${YELLOW}$TARGET_URL${NC}"
echo -e "Siklus : ${YELLOW}$SIKLUS${NC}"
echo ""

# Log file
LOG_FILE="/tmp/auto-view-v2-$(date +%Y%m%d-%H%M%S).log"
echo -e "${CYAN}Log file: $LOG_FILE${NC}"
echo ""

cd /opt/project/spammer/views-tiktok-v2/source

# Jalanin dengan tee (tampil + simpan)
set +e
python3 tiktok_mobile.py "$TARGET_URL" "$SIKLUS" 2>&1 | tee "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}
set -e

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Selesai. Log: $LOG_FILE${NC}"
else
    echo -e "${RED}❌ Gagal (exit code: $EXIT_CODE). Log: $LOG_FILE${NC}"
fi
