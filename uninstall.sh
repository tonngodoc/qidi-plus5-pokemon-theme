#!/usr/bin/env bash
# ==============================================================================
# QIDI Plus 5 - Pokemon Custom UI Theme Uninstaller
# Khôi phục biểu tượng màn hình gốc của nhà sản xuất QIDI
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}======================================================${NC}"
echo -e "${YELLOW}   RESTORE FACTORY UI ICONS / KHÔI PHỤC BIỂU TƯỢNG GỐC ${NC}"
echo -e "${CYAN}======================================================${NC}"

ACCESS_DIR="/home/qidi/QIDI_Client/access"
BACKUP_DIR="/home/qidi/QIDI_Client/access_backup"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}[!] Error: Backup directory not found at $BACKUP_DIR!${NC}"
    echo -e "${RED}[!] Cannot restore factory assets automatically.${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Stopping UI service...${NC}"
echo qiditech | sudo -S systemctl stop qidi-client 2>/dev/null || true

echo -e "${YELLOW}[*] Restoring original factory assets from $BACKUP_DIR...${NC}"
cp -rf "$BACKUP_DIR/navi/"* "$ACCESS_DIR/navi/" 2>/dev/null || true
cp -rf "$BACKUP_DIR/setting/"* "$ACCESS_DIR/setting/" 2>/dev/null || true
cp -rf "$BACKUP_DIR/message/"* "$ACCESS_DIR/message/" 2>/dev/null || true
cp -rf "$BACKUP_DIR/home/"* "$ACCESS_DIR/home/" 2>/dev/null || true
cp -rf "$BACKUP_DIR/control/"* "$ACCESS_DIR/control/" 2>/dev/null || true

echo -e "${YELLOW}[*] Starting UI service...${NC}"
echo qiditech | sudo -S systemctl start qidi-client

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}   FACTORY ASSETS RESTORED! / ĐÃ KHÔI PHỤC BẢN GỐC!    ${NC}"
echo -e "${GREEN}======================================================${NC}"
