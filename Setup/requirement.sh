#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# (C) Copyright 2022 Oleh KaizenVPN
# ═══════════════════════════════════════════════════════════════════
# Nama        : Autoskrip VPN
# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
# OS Support  : Ubuntu & Debian
# Owner       : KaizenVPN
# Telegram    : https://t.me/KaizenA
# Github      : github.com/rewasu91
# ═══════════════════════════════════════════════════════════════════

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# ══════════════════════════
# // Export Warna & Maklumat
# ══════════════════════════
export RED='\033[1;91m';
export GREEN='\033[1;92m';
export YELLOW='\033[1;93m';
export BLUE='\033[1;94m';
export PURPLE='\033[1;95m';
export CYAN='\033[1;96m';
export LIGHT='\033[1;97m';
export NC='\033[0m';

# ════════════════════════════════
# // Export Maklumat Status Banner
# ════════════════════════════════
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export REDBG='\e[41m';
export WBBG='\e[1;47;30m';

# ═══════════════
# // Export Align
# ═══════════════
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# ════════════════════════════
# // Export Maklumat Sistem OS
# ════════════════════════════
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# ═══════════════════════════════════
# // String Untuk Membantu Pemasangan
# ═══════════════════════════════════
export VERSION="2.0";
export EDITION="Multiport Edition";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/kaizenvpn";
export CORE_DIRECTORY="/usr/local/kaizenvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh";
export REPO_URL="https://github.com/rewasu91/scvps";

# ═══════════════
# // Allow Access
# ═══════════════
BURIQ () {
    curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)
Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}
PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
echo -e "${ERROR} Permission Denied!";
exit 0
fi

# ═════════════════════════════════════════════════════════
# // Semak kalau anda sudah running sebagai root atau belum
# ═════════════════════════════════════════════════════════
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# ═════════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang / No
# ═════════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
    clear;
    echo -e "${ERROR} Pakej JQ tidak dipasang";
    exit 1;
fi

# ═══════════════════════════════
# // Exporting maklumat rangkaian
# ═══════════════════════════════
wget -qO- --inet4-only 'https://raw.githubusercontent.com/rewasu91/scvpssettings/main/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# ══════════════════
# // Memasang Update
# ══════════════════
apt update -y;
apt upgrade -y;
apt dist-upgrade -y;
apt remove --purge ufw firewalld exim4 -y;
apt autoremove -y;
apt clean -y;

# ══════════════════════════
# // Memasang Alat Keperluan
# ══════════════════════════
apt install python -y;
apt install make-guile -y;
apt install make -y;
apt install cmake -y;
apt install coreutils -y;
apt install rsyslog -y;
apt install net-tools -y;
apt install zip -y;
apt install unzip -y;
apt install nano -y;
apt install sed -y;
apt install gnupg -y;
apt install gnupg1 -y;
apt install bc -y;
apt install jq -y;

# ════════════════════════════════════════════════
# // Membuang cache dan sambung memasang keperluan
# ════════════════════════════════════════════════
apt autoremove -y; 
apt clean -y
apt install apt-transport-https -y;
apt install build-essential -y;
apt install dirmngr -y;
apt install libxml-parser-perl -y;
apt install git -y;
apt install lsof -y;
apt install libsqlite3-dev -y;
apt install libz-dev -y;
apt install gcc -y;
apt install g++ -y;
apt install libreadline-dev -y;
apt install zlib1g-dev -y;
apt install libssl-dev -y;
apt install neofetch -y;

# ════════════════════
# // Memasang Neofetch
# ════════════════════
wget -q -O /usr/local/sbin/neofetch "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/neofetch"; chmod +x /usr/local/sbin/neofetch;

# ══════════════════
# // Menetapkan masa
# ══════════════════
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;

# ═══════════════════════
# // Mendapatkan route IP
# ═══════════════════════
export NET=$(ip route show default | awk '{print $5}');
export MYIP2="s/xxxxxxxxx/$IP_NYA/g";

# ══════════════════════
# // Memasang Vnstat 2.9
# ══════════════════════
apt install vnstat -y;
/etc/init.d/vnstat stop;
wget -q -O vnstat.zip "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/vnstat.zip";
unzip -o vnstat.zip > /dev/null 2>&1;
cd vnstat;
chmod +x configure;
./configure --prefix=/usr --sysconfdir=/etc --disable-dependency-tracking && make && make install;
cd;
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf;
chown vnstat:vnstat /var/lib/vnstat -R;
systemctl disable vnstat;
systemctl enable vnstat;
systemctl restart vnstat;
/etc/init.d/vnstat restart;
rm -r -f vnstat;
rm -f vnstat.zip;

# ════════════════════
# // Memasang UDP mini
# ════════════════════
wget -q -O /usr/local/kaizenvpn/udp-mini "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/udp-mini";
chmod +x /usr/local/kaizenvpn/udp-mini;
wget -q -O /etc/systemd/system/udp-mini-1.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/udp-mini-1.service";
wget -q -O /etc/systemd/system/udp-mini-2.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/udp-mini-2.service";
wget -q -O /etc/systemd/system/udp-mini-3.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/udp-mini-3.service";
systemctl disable udp-mini-1 > /dev/null 2>&1;
systemctl stop udp-mini-1 > /dev/null 2>&1;
systemctl enable udp-mini-1;
systemctl start udp-mini-1;
systemctl disable udp-mini-2 > /dev/null 2>&1;
systemctl stop udp-mini-2 > /dev/null 2>&1;
systemctl enable udp-mini-2;
systemctl start udp-mini-2;
systemctl disable udp-mini-3 > /dev/null 2>&1;
systemctl stop udp-mini-3 > /dev/null 2>&1;
systemctl enable udp-mini-3;
systemctl start udp-mini-3;

# ═══════════════════════════════════
# // Blok Torrent menggunakan iptable
# ═══════════════════════════════════
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP;
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP;
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP;
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP;
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP;
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP;
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save;
netfilter-persistent reload;

# ═══════════════════════
# // Memasang Squid Proxy
# ═══════════════════════
apt install squid -y;
wget -q -O /etc/squid/squid.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/squid_conf";
sed -i $MYIP2 /etc/squid/squid.conf;
mkdir -p /etc/kaizenvpn/squid;
/etc/init.d/squid restart;

# ══════════════════════
# // Memasangg OHP Proxy
# ══════════════════════
wget -q -O /usr/local/kaizenvpn/ohp-mini "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/ohp-mini";
chmod +x /usr/local/kaizenvpn/ohp-mini
wget -q -O /etc/systemd/system/ohp-mini-1.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ohp-mini-1_service"
wget -q -O /etc/systemd/system/ohp-mini-2.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ohp-mini-2_service"
wget -q -O /etc/systemd/system/ohp-mini-3.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ohp-mini-3_service"
wget -q -O /etc/systemd/system/ohp-mini-4.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ohp-mini-4_service"
systemctl disable ohp-mini-1 > /dev/null 2>&1
systemctl stop ohp-mini-1 > /dev/null 2>&1
systemctl enable ohp-mini-1
systemctl start ohp-mini-1
systemctl disable ohp-mini-2 > /dev/null 2>&1
systemctl stop ohp-mini-2 > /dev/null 2>&1
systemctl enable ohp-mini-2
systemctl start ohp-mini-2
systemctl disable ohp-mini-3 > /dev/null 2>&1
systemctl stop ohp-mini-3 > /dev/null 2>&1
systemctl enable ohp-mini-3
systemctl start ohp-mini-3
systemctl disable ohp-mini-4 > /dev/null 2>&1
systemctl stop ohp-mini-4 > /dev/null 2>&1
systemctl enable ohp-mini-4
systemctl start ohp-mini-4

# ═════════════════════════════════════════════════════════════════
# // Memasang Autokill Untuk Vmess Vless Trojan Shadowsocks dan SSH
# ═════════════════════════════════════════════════════════════════
wget -q -O /etc/systemd/system/ssh-kill.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ssh-kill_service";
wget -q -O /etc/systemd/system/vmess-kill.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/vmess-kill_service";
wget -q -O /etc/systemd/system/vless-kill.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/vless-kill_service";
wget -q -O /etc/systemd/system/trojan-kill.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/trojan-kill_service";
wget -q -O /etc/systemd/system/ss-kill.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ss-kill_service";
wget -q -O /usr/local/kaizenvpn/vmess-auto-kill "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/vmess-kill.sh"; chmod +x /usr/local/kaizenvpn/vmess-auto-kill;
wget -q -O /usr/local/kaizenvpn/ssh-auto-kill "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/ssh-kill.sh"; chmod +x /usr/local/kaizenvpn/ssh-auto-kill;
wget -q -O /usr/local/kaizenvpn/vless-auto-kill "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/vless-kill.sh"; chmod +x /usr/local/kaizenvpn/vless-auto-kill;
wget -q -O /usr/local/kaizenvpn/trojan-auto-kill "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/trojan-kill.sh"; chmod +x /usr/local/kaizenvpn/trojan-auto-kill;
wget -q -O /usr/local/kaizenvpn/ss-auto-kill "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/ss-kill.sh"; chmod +x /usr/local/kaizenvpn/ss-auto-kill;
wget -q -O /etc/kaizenvpn/autokill.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/autokill_conf"; chmod +x /etc/kaizenvpn/autokill.conf;
systemctl enable vmess-kill;
systemctl enable ssh-kill;
systemctl enable vless-kill;
systemctl enable trojan-kill;
systemctl enable ss-kill;
systemctl start vmess-kill;
systemctl start ssh-kill;
systemctl start vless-kill;
systemctl start trojan-kill;
systemctl start ss-kill;
systemctl restart vmess-kill;
systemctl restart ssh-kill;
systemctl restart vless-kill;
systemctl restart trojan-kill;
systemctl restart ss-kill;

# ══════════════════
# // Memasang Rclone
# ══════════════════
curl -s https://rclone.org/install.sh | bash > /dev/null 2>&1
printf "q\n" | rclone config > /dev/null 2>&1

# ══════════════════════════════════════
# // Input auto expired untuk semua user
# ══════════════════════════════════════
echo "0 0 * * * root /usr/local/sbin/autoexp" > /etc/cron.d/autoexp
echo "0 * * * * root /usr/local/sbin/clearlog" > /etc/cron.d/clearlog
systemctl restart cron

# ════════════════════
# // Memasang Fail2ban
# ════════════════════
apt install fail2ban -y;
/etc/init.d/fail2ban restart;

# ═══════════════════════════
# // Set kepada default login
# ═══════════════════════════
echo "autoexp && clear" >> /etc/profile 
echo "clearlog && clear && neofetch" >> /etc/profile

# ════════════════════
# // Memasang RC-Local
# ════════════════════
wget -q -O /etc/systemd/system/rc-local.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/rc-local_service";
wget -q -O /etc/rc.local "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/rc-local_conf";
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f /root/requirement.sh;

# ══════════
# // Selesai
# ══════════
clear;
echo -e "${OKEY} Selesai memasang alat bantuan skrip";
