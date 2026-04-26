#!/bin/bash
# ==================================================
# UDP Custom Installer – @OfficialOnePesewa
# Run as root: bash <(curl -sSL https://raw.githubusercontent.com/OfficialOnePesewa/op-udp-custom/main/install.sh)
# ==================================================
[[ "$(whoami)" != "root" ]] && {
    echo -e "\033[1;31mError: Run as root\033[0m"
    exit 1
}

GITHUB_USER="OfficialOnePesewa"
REPO="op-udp-custom"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO/$BRANCH"
NEW_PORT="47712"
NEW_UDPGW_PORT="7400"

apt update -y && apt upgrade -y
apt install -y wget curl dos2unix neofetch cron

source <(curl -sSL "$BASE_URL/module/module")

time_reboot() {
  print_center -ama "System/Server Reboot In $1 Seconds"
  local sec=$1
  while [ $sec -gt 0 ]; do
    print_center -ne "-$sec-\r"
    sleep 1
    ((sec--))
  done
  rm -f /home/ubuntu/install.sh /root/install.sh
  echo -e "\033[1;33mMore Updates, Follow Us On \033[1;36mTelegram\033[1;33m: \033[1;37m@OfficialOnePesewa\033[0m"
  reboot
}

if [[ "$(lsb_release -rs)" =~ ^(8|9|10|11|16.04|18.04) ]]; then
  clear
  print_center -ama "====================================================="
  print_center -ama "Incompatible OS. Use Ubuntu 20.04 or later."
  print_center -ama "====================================================="
  exit 1
fi

clear
echo ""
print_center -ama "Compatible OS found. Installing..."
sleep 3

ln -fs /usr/share/zoneinfo/Africa/Accra /etc/localtime
systemctl stop udpgw udp-custom 2>/dev/null
rm -rf /etc/UDPCustom /root/udp /usr/bin/udp /usr/bin/opcustom /etc/systemd/system/udpgw.service /etc/systemd/system/udp-custom.service /etc/limiter.sh /etc/cek.sh

mkdir -p /etc/UDPCustom /root/udp

# Download files
wget -qO /etc/UDPCustom/module "$BASE_URL/module/module"
chmod +x /etc/UDPCustom/module

wget -qO /root/udp/udp-custom "$BASE_URL/bin/udp-custom-linux-amd64"
chmod +x /root/udp/udp-custom

wget -qO /etc/limiter.sh "$BASE_URL/module/limiter.sh"
cp /etc/limiter.sh /etc/UDPCustom/limiter.sh
chmod +x /etc/limiter.sh /etc/UDPCustom/limiter.sh

wget -qO /etc/cek.sh "$BASE_URL/module/cek.sh"
cp /etc/cek.sh /etc/UDPCustom/cek.sh
chmod +x /etc/cek.sh /etc/UDPCustom/cek.sh

wget -qO /bin/udpgw "$BASE_URL/module/udpgw"
chmod +x /bin/udpgw

wget -qO /etc/systemd/system/udpgw.service "$BASE_URL/config/udpgw.service"
wget -qO /etc/systemd/system/udp-custom.service "$BASE_URL/config/udp-custom.service"
chmod 640 /etc/systemd/system/udpgw.service /etc/systemd/system/udp-custom.service

wget -qO /root/udp/config.json "$BASE_URL/config/config.json"
sed -i "s/\"listen\":.*/\"listen\": \":$NEW_PORT\",/" /root/udp/config.json
sed -i "s/\"udpgw_port\":.*/\"udpgw_port\": $NEW_UDPGW_PORT,/" /root/udp/config.json 2>/dev/null

# ✅ CHANGED: Use opcustom instead of udp
wget -qO /usr/bin/opcustom "$BASE_URL/module/opcustom"
chmod +x /usr/bin/opcustom

systemctl daemon-reload
systemctl enable udpgw --now
systemctl enable udp-custom --now

ufw disable 2>/dev/null
apt-get remove --purge ufw firewalld -y 2>/dev/null
apt remove netfilter-persistent -y 2>/dev/null

clear
print_center -ama "Installation Complete"
print_center -ama "Type: opcustom"
msg -bar
