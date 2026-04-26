#!/bin/bash
# ==================================================
# OP UDP CUSTOM – OfficialOnePesewa
# Isolated install in /opt/op-udp-custom
# Run as root: bash <(curl -sSL https://raw.githubusercontent.com/OfficialOnePesewa/op-udp-custom/main/install.sh)
# ==================================================
[[ "$(whoami)" != "root" ]] && {
    echo -e "\033[1;31mError: Run as root\033[0m"
    exit 1
}

BASE="https://raw.githubusercontent.com/OfficialOnePesewa/op-udp-custom/main"
INSTALL_DIR="/opt/op-udp-custom"
NEW_PORT="47712"
NEW_UDPGW_PORT="7400"

apt update -y && apt upgrade -y
apt install -y wget curl dos2unix neofetch cron jq

clear
echo -e "\033[1;36m
  ██████╗ ██████╗     ██╗   ██╗██████╗ ██████╗
 ██╔═══██╗██╔══██╗    ██║   ██║██╔══██╗██╔══██╗
 ██║   ██║██████╔╝    ██║   ██║██║  ██║██████╔╝
 ██║   ██║██╔═══╝     ██║   ██║██║  ██║██╔═══╝
 ╚██████╔╝██║         ╚██████╔╝██████╔╝██║
  ╚═════╝ ╚═╝          ╚═════╝ ╚═════╝ ╚═╝
\033[0m"
echo -e "\033[1;33m   TELEGRAM: @OfficialOnePesewa   \033[0m"
sleep 2

echo "Setting timezone to GMT"
ln -fs /usr/share/zoneinfo/Africa/Accra /etc/localtime

# Stop any old op-udp services
systemctl stop op-udpgw op-udp-custom 2>/dev/null
rm -rf "$INSTALL_DIR"

mkdir -p "$INSTALL_DIR"/{bin,module}

# Download binary
wget -q "$BASE/bin/udp-custom-linux-amd64" -O "$INSTALL_DIR/bin/udp-custom"
chmod +x "$INSTALL_DIR/bin/udp-custom"

# Download udpgw binary
wget -q "$BASE/module/udpgw" -O "$INSTALL_DIR/bin/udpgw"
chmod +x "$INSTALL_DIR/bin/udpgw"

# Config
wget -q "$BASE/config/config.json" -O "$INSTALL_DIR/config.json"

# Module scripts
wget -q "$BASE/module/module" -O "$INSTALL_DIR/module/module"
chmod +x "$INSTALL_DIR/module/module"

wget -q "$BASE/module/opcustom" -O "$INSTALL_DIR/module/opcustom"
chmod +x "$INSTALL_DIR/module/opcustom"

wget -q "$BASE/module/limiter.sh" -O "$INSTALL_DIR/module/limiter.sh"
chmod +x "$INSTALL_DIR/module/limiter.sh"

wget -q "$BASE/module/cek.sh" -O "$INSTALL_DIR/module/cek.sh"
chmod +x "$INSTALL_DIR/module/cek.sh"

# Systemd services
cp "$INSTALL_DIR/module/opcustom" /usr/local/bin/opcustom  # for convenience

wget -q "$BASE/config/op-udpgw.service" -O /etc/systemd/system/op-udpgw.service
wget -q "$BASE/config/op-udp-custom.service" -O /etc/systemd/system/op-udp-custom.service
sed -i "s|INSTALL_DIR|$INSTALL_DIR|g" /etc/systemd/system/op-udpgw.service
sed -i "s|INSTALL_DIR|$INSTALL_DIR|g" /etc/systemd/system/op-udp-custom.service

systemctl daemon-reload
systemctl enable op-udpgw --now
systemctl enable op-udp-custom --now

ufw disable 2>/dev/null
apt-get remove --purge ufw firewalld -y 2>/dev/null
apt remove netfilter-persistent -y 2>/dev/null

clear
echo -e "\033[1;32m
╔══════════════════════════════════════╗
║  OP UDP CUSTOM INSTALLED SUCCESSFULLY ║
╠══════════════════════════════════════╣
║ Type: opcustom                      ║
║ Telegram: @OfficialOnePesewa        ║
╚══════════════════════════════════════╝
\033[0m"
