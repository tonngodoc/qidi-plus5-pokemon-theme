#!/usr/bin/env bash
# ==============================================================================
# QIDI Plus 5 - Pokemon Custom UI Theme Installer (Bản Nội Địa)
# Gói giao diện Pokemon cho màn hình máy in 3D QIDI Plus 5
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}======================================================${NC}"
echo -e "${YELLOW}   ⚡ QIDI PLUS 5 - POKEMON CUSTOM UI THEME INSTALLER ⚡  ${NC}"
echo -e "${GREEN}   (Giao diện Pokemon cho màn hình cảm ứng QIDI Plus 5)  ${NC}"
echo -e "${CYAN}   Tác giả: TÔN NGỘ ĐỘC | https://hawklabs.vn           ${NC}"
echo -e "${CYAN}======================================================${NC}"

ACCESS_DIR="/home/qidi/QIDI_Client/access"
BACKUP_DIR="/home/qidi/QIDI_Client/access_backup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_URL="https://raw.githubusercontent.com/tonngodoc/qidi-plus5-pokemon-theme/main"

# 1. Check environment
if [ ! -d "$ACCESS_DIR" ]; then
    echo -e "${RED}[!] Error: Directory $ACCESS_DIR not found!${NC}"
    echo -e "${RED}[!] Please make sure you are running this on a QIDI 3D printer.${NC}"
    exit 1
fi

# 2. Backup factory assets if not already backed up
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}[1/4] Creating factory assets backup in $BACKUP_DIR...${NC}"
    mkdir -p "$BACKUP_DIR"
    cp -r "$ACCESS_DIR/navi" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$ACCESS_DIR/setting" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$ACCESS_DIR/message" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$ACCESS_DIR/home" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$ACCESS_DIR/control" "$BACKUP_DIR/" 2>/dev/null || true
    echo -e "${GREEN}[+] Factory backup saved successfully.${NC}"
else
    echo -e "${GREEN}[+] Factory backup already exists at $BACKUP_DIR.${NC}"
fi

# 3. Download or locate theme files
TMP_DIR="/tmp/qidi_pokemon_theme_install"
if [ ! -d "$SCRIPT_DIR/theme" ]; then
    echo -e "${YELLOW}[2/4] Downloading Pokemon theme package from GitHub...${NC}"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    curl -sSL "$BASE_URL/theme.tar.gz" -o "$TMP_DIR/theme.tar.gz"
    tar -xzf "$TMP_DIR/theme.tar.gz" -C "$TMP_DIR"
    curl -sSL "$BASE_URL/uninstall.sh" -o "/home/qidi/uninstall_pokemon_theme.sh"
    chmod +x "/home/qidi/uninstall_pokemon_theme.sh"
    SOURCE_DIR="$TMP_DIR"
else
    SOURCE_DIR="$SCRIPT_DIR/theme"
fi

# 4. Stop service and copy theme files
echo -e "${YELLOW}[3/4] Stopping UI service & applying Pokemon icons...${NC}"
echo qiditech | sudo -S systemctl stop qidi-client 2>/dev/null || true

cp -rf "$SOURCE_DIR/navi/"* "$ACCESS_DIR/navi/" 2>/dev/null || true
cp -rf "$SOURCE_DIR/setting/"* "$ACCESS_DIR/setting/" 2>/dev/null || true
cp -rf "$SOURCE_DIR/message/"* "$ACCESS_DIR/message/" 2>/dev/null || true
cp -rf "$SOURCE_DIR/home/"* "$ACCESS_DIR/home/" 2>/dev/null || true
cp -rf "$SOURCE_DIR/control/"* "$ACCESS_DIR/control/" 2>/dev/null || true

# 5. Restart service
echo -e "${YELLOW}[4/4] Restarting screen UI service...${NC}"
echo qiditech | sudo -S systemctl start qidi-client

# Telemetry counter (anonymous install badge counter)
curl -s "https://abacus.jasoncameron.dev/hit/tonngodoc-qidi-plus5-pokemon-theme/installs" >/dev/null 2>&1 || true

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}   ✨ INSTALLATION COMPLETED! / CÀI ĐẶT THÀNH CÔNG! ✨ ${NC}"
echo -e "${CYAN}   - Thiết bị: QIDI Plus 5 (Bản Nội địa)${NC}"
echo -e "${CYAN}   - Tác giả: TÔN NGỘ ĐỘC | https://hawklabs.vn${NC}"
echo -e "${CYAN}   - Navigation Tabs: Pikachu, Charmander, Bulbasaur, Snorlax, Squirtle${NC}"
echo -e "${CYAN}   - Control Page: CNC Precision Silver Icons (XYZ, Extruder, Chamber, Bed, Fan)${NC}"
echo -e "${CYAN}   - Avatar: Pokeball / Assistant: Pikachu${NC}"
echo -e "${CYAN}   - Uninstall command: bash /home/qidi/uninstall_pokemon_theme.sh${NC}"
echo -e "${GREEN}======================================================${NC}"
