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

# ══════════════════════════
# // Membuat Directory Utama
# ══════════════════════════
if [[ -r /usr/local/kaizenvpn/ ]]; then
        echo -e "${ERROR} Skrip sudah dipasang !"
        sleep 3
        clear
        echo ""
        echo -e "            ${RED} ! AMARAN !${NC}"
        echo -e "kalau anda reinstall skrip ini, anda akan kehilangan"
        echo -e "semua data skrip seperti data pelanggan dan lain-lain"
        echo -e "kalau anda yakin untuk meneruskan, sila taip okey"
        echo -e ""
        read -p "Sila taip 'okey' untuk mengesahkan memasang semula skrip : " configm
        if [[ $configm == "okey" ]]; then
                clear
                echo -e "${OKEY} Baiklah, sistem akan mula memasang semula skrip";
                sleep 1
        else
                clear
                echo -e "${ERROR} Pemasangan semula skrip telah dibatalkan";
                exit 1
        fi
        export STATUS_SC1="reinstall"
else
        export passed=true # Script Not Detected
fi

# ═════════════════
# // Membuat Folder
# ═════════════════
rm -rf /etc/kaizenvpn/;
rm -rf /usr/local/kaizenvpn/;
rm -rf /etc/v2ray/;
rm -rf /etc/xray/;
mkdir -p /etc/kaizenvpn/;

# ══════════════════
# // Menetapkan masa
# ══════════════════
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;

# ════════════════════════
# // Persetujuan peraturan
# ════════════════════════
wget -q -O /etc/kaizenvpn/Rules "https://raw.githubusercontent.com/rewasu91/scvpssettings/main/rules.txt";
clear;
bacadulu ()
{
cat /etc/kaizenvpn/Rules;
echo "";
echo -e "    Untuk meneruskan pemasangan skrip, sila baca dan ";
echo -e "    anda perlu bersetuju dengan terma dan syarat kami.";
echo -e "    Sekiranya anda bersetuju, sila taip '${YELLOW}okey${NC}'";
echo "";
read -p '    Taip 'okey' sebagai tanda setuju : ' accepted_rules;
if [[ $accepted_rules == "okey" ]]; then
    echo "";
    echo -e "    ${OKEY} Anda telah bersetuju dengan terma dan syarat kami.";
    echo -e "    Sistem akan memulakan pemasangan skrip dalam masa 2 saat.";
    sleep 2;
    clear;
else
    echo "";
    echo -e "    ${ERROR} Maaf, anda tidak boleh meneruskan pemasangan skrip";
    echo -e "    kerana anda tidak bersetuju dengan peraturan kami.";
    bacadulu
fi 
}
bacadulu

# ═══════════════════════
# // Membuat folder local
# ═══════════════════════
mkdir -p /usr/local/kaizenvpn/;
mkdir -p /etc/kaizenvpn/bin/;
mkdir -p /etc/kaizenvpn/local/;
mkdir -p /etc/kaizenvpn/sbin/;
mkdir -p /etc/kaizenvpn/snc-relay/;
mkdir -p /etc/kaizenvpn/python-vrt/;
mkdir -p /etc/kaizenvpn/panel-controller/;
mkdir -p /etc/kaizenvpn/addons-controller/;
mkdir -p /etc/kaizenvpn/build/;
mkdir -p /etc/kaizenvpn/data/;

# ══════════════════════════════════════
# // Update dan upgrade semua repository
# ══════════════════════════════════════
apt update -y;
apt upgrade -y;
apt autoremove -y;
apt dist-upgrade -y;
apt install jq -y;
apt install wget -y;
apt install nano -y;
apt install curl -y;

# ═════════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang / No
# ═════════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    echo -e "${ERROR} Pakej JQ tidak dipasang";
    exit 1
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

# ═══════════════════
# // Exporting Banner
# ═══════════════════
clear
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}
   Selamat Datang ke KaizenVPN Skrip V2.0 Stable
Skrip ini akan memasang server vpn secara automatik
                 Owner : ${GREEN}KaizenVPN${NC}
        © Copyright 2022-2023 By ${GREEN}KaizenVpn${NC}
${CYAN}═══════════════════════════════════════════════════${NC}";

# ═════════════
# // Pengesahan
# ═════════════
echo -e "${OKEY} Versi Skrip [ ${GREEN}${VERSION} ${EDITION}${NC} ]";

# ═══════════════════════════
# // Mengesahkan Architecture
# ═══════════════════════════
if [[ $OS_ARCH == "x86_64" ]]; then
    echo -e "${OKEY} Architecture Supported [ $GREEN$OS_ARCH${NC} ]";
else
    echo -e "${ERROR} Architecture Supported [ $RED$OS_ARCH${NC} ]";
    exit 1;
fi

# ═══════════════════════════════════════════
# // Mengesahkan Sistem OS support atau tidak
# ═══════════════════════════════════════════
if [[ $OS_ID == "ubuntu" ]]; then
    # // Ubuntu Detected
    if [[ $OS_VERSION == "16.04" ]]; then
        # // Ubuntu 16.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "18.04" ]]; then
        # // Ubuntu 18.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "20.04" ]]; then
        # // Ubuntu 20.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "20.10" ]]; then
        # // Ubuntu 20.10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "21.04" ]]; then
        # // Ubuntu 21.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "21.10" ]]; then
        # // Ubuntu 21.10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "22.04" ]]; then
        # // Ubuntu 22.04
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "22.10" ]]; then
        # // Ubuntu 22.10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    else
        # // No Supported OS
        echo -e "${ERROR} OS Not Supported [ ${RED}$OS_NAME${NC} ]";
        exit 1;
    fi
elif [[ $OS_ID == "debian" ]]; then
    # // Debian Detected
    if [[ $OS_VERSION == "8" ]]; then
        # // Debian 8
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "9" ]]; then
        # // Debian 9
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "10" ]]; then
        # // Debian 10
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "11" ]]; then
        # // Debian 11
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    elif [[ $OS_VERSION == "12" ]]; then
        # // Debian 12
        echo -e "${OKEY} OS Supported [ ${GREEN}$OS_NAME${NC} ]";
    else
        # // No Supported OS
        echo -e "${ERROR} OS Not Supported [ ${RED}$OS_NAME${NC} ]";
        exit 1;
    fi
else
    # // Operating Not Supported
    echo -e "${ERROR} Maaf, hanya support sistem Debian & Ubuntu sahaja";
    exit 1;
fi

# ═══════════════
# // Maklumat Ram
# ═══════════════
while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))";
Ram_Total="$((mem_total / 1024))";

# ══════════════════════════════
# // Mendaftarkan pengguna skrip
# ══════════════════════════════
Username="script-$( </dev/urandom tr -dc 0-9 | head -c5 )";
Password="$( </dev/urandom tr -dc 0-9 | head -c12 )";
mkdir -p /home/script/;
useradd -r -d /home/script -s /bin/bash -M $Username;
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1;
usermod -aG sudo $Username > /dev/null 2>&1;

# ══════════════════════════════════════
# // Selamat Datang ke Proses Pemasangan
# ══════════════════════════════════════
clear && echo -e "${OKEY} Memulakan proses pemasangan skrip.";

# ═══════════════════
# // Info Versi Skrip
# ═══════════════════
printf 'VERSION=2.0\nPATCH="1"\nNAME=Multiport Edition\nVERSION_ID="Multi"' > /etc/kaizenvpn/version

# ════════════════════════════════════
# // Membuang Apache / Nginx kalau ada
# ════════════════════════════════════
apt remove --purge nginx -y;
apt remove --purge apache2 -y;
apt autoremove -y;

# ══════════════════════════════════════
# // Memasang keperluan lain untuk skrip
# ══════════════════════════════════════
apt install jq -y;
apt install net-tools -y;
apt install netfilter-persistent -y;
apt install openssl -y;
apt install iptables -y;
apt install iptables-persistent -y;
apt autoremove -y;
apt-get install socat;
apt-get install figlet;
apt-get install cowsay fortune-mod -y;
ln -s /usr/games/cowsay /bin;
ln -s /usr/games/fortune /bin;

# ════════════════════
# // Memasang BBR & FQ
# ════════════════════
cat > /etc/sysctl.conf << END
# Sysctl Config By KaizenVPN
# ════════════════════════════════════════════════════════════
# Please do not try to change / modif this config
# This file is for enable bbr & disable ipv6 
# if you modifed this, bbr & ipv6 disable will error
# ════════════════════════════════════════════════════════════
# (C) Copyright 2022-2023 By KaizenVPN

# ════════════════════════════
# // Mengaktifkan IPv4 Forward
# ════════════════════════════
net.ipv4.ip_forward=1

# ═════════════════
# // Mematikan IPV6
# ═════════════════
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# ════════════════════════
# // Mengaktifkan bbr & fq
# ════════════════════════
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
END
sysctl -p;

# ════════════════════════════════════════════════════════════════
# // Memasang Socat & membuang nginx & apache kalau sudah dipasang
# ════════════════════════════════════════════════════════════════
clear;
apt install socat -y;
apt install sudo -y;

# ═════════════════════
# // Mengentikan servis
# ═════════════════════
systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1
systemctl stop nginx > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1

# ════════════════════════════════════════════════
# // Mematikan port 80 & 443 kalau sudah digunakan
# ════════════════════════════════════════════════
lsof -t -i tcp:80 -s tcp:listen | xargs kill > /dev/null 2>&1
lsof -t -i tcp:443 -s tcp:listen | xargs kill > /dev/null 2>&1

# ═════════════════
# // Setting Domain
# ═════════════════
clear;
echo "";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "${WBBG}           [ Setting Domain ]             ${NC}";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "";
echo -e " ${CYAN}Guna domain sendiri / domain automatik?${NC}";
echo -e " ${GREEN}[ 01 ]${NC} ► Guna domain sendiri";
echo -e " ${GREEN}[ 02 ]${NC} ► Guna domain automatik (free wildcard)";

echo -e "";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo "";
read -p "$( echo -e "${GREEN}Sila masukkan nombor pilihan anda${NC} (${YELLOW}1/2${NC}) :" )" choose_domain

# ══════════════════════════════════════════════
# // Mengesahkan pilihan domain, samada 1 atau 2
# ══════════════════════════════════════════════
if [[ $choose_domain == "2" ]]; then # // Menggunakan domain automatik
clear;
wget https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/freedomain.sh && chmod +x freedomain.sh && ./freedomain.sh
clear;
echo -e "${OKEY} Mulai membuat certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/rewasu91/scvpssettings/main/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@kaizenvpn.me;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256 --force;

# ══════════════════
# // Maklumat Domain
# ══════════════════
clear;
echo "";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "${WBBG}          [ Maklumat Domain ]             ${NC}";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "";
domain=$( cat /etc/kaizenvpn/domain.txt );
echo -e "  ${OKEY} Domain anda ialah : ${domain}";
echo -e "  ${OKEY} Wildcard anda     : bug.com.${domain}";
echo -e "  Tukarkan bug.com kepada apa-apa sahaja bug anda.";
sleep 4;
clear;

# ═════════════════════════════
# // Menggunakan domain sendiri
# ═════════════════════════════
elif [[ $choose_domain == "1" ]]; then
clear;
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "${WBBG}           [ Setting Domain ]             ${NC}";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "";
read -p "  Sila masukkan Domain anda : " domain
domain=$( echo $domain | sed 's/ //g' );
if [[ $domain == "" ]]; then
    clear;
    echo -e "  ${ERROR} Tiada input dikesan, sila taip domain anda !";
    exit 1;
fi
echo "$domain" > /etc/kaizenvpn/domain.txt;
domain=$( cat /etc/kaizenvpn/domain.txt );
clear;
echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/rewasu91/scvpssettings/main/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@kaizenvpn.me;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256 --force;

# ══════════════════
# // Maklumat Domain
# ══════════════════
clear;
echo "";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "${WBBG}          [ Maklumat Domain ]             ${NC}";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "";
echo -e "  ${OKEY} Domain anda ialah : ${domain}";
sleep 4;
clear;

else
    echo -e "  ${ERROR} Sila pilih 1 atau 2 sahaja !";
    exit 1;
fi

clear;

# ══════════════════════════════
# // Memasang alat bantuan skrip
# ══════════════════════════════
wget -q -O /root/requirement.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/requirement.sh";
chmod +x requirement.sh;
./requirement.sh;
clear;

# ═══════════════════════════
# // Memasang SSH & Websocket
# ═══════════════════════════
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/ssh-ssl.sh";
chmod +x ssh-ssl.sh;
./ssh-ssl.sh;
clear;

# ═════════════════
# // Memasang Nginx
# ═════════════════
wget -q -O /root/nginx.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/nginx.sh";
chmod +x nginx.sh;
./nginx.sh;
clear;

# ═════════════════════
# // Memasang XRay Mini
# ═════════════════════
wget -q -O /root/xray-mini.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/xray-mini.sh";
chmod +x xray-mini.sh;
./xray-mini.sh;
clear;

# ═══════════════════
# // Memasang OpenVPN
# ═══════════════════
wget -q -O /root/ovpn.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/ovpn.sh";
chmod +x ovpn.sh;
./ovpn.sh;
clear;

# ═════════════════════
# // Memasang Wireguard
# ═════════════════════
wget -q -O /root/wg-set.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/wg-set.sh";
chmod +x wg-set.sh;
./wg-set.sh;
clear;

# ════════════════════════
# // Memasang ShadowsocksR
# ════════════════════════
wget -q -O /root/ssr.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/ssr.sh";
chmod +x ssr.sh;
./ssr.sh;
clear;

# ════════════════
# // Memasang Menu
# ════════════════
wget -q -O /root/menu-setup.sh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/menu-setup.sh";
chmod +x menu-setup.sh;
./menu-setup.sh;
clear;

# ══════════
# // Selesai
# ══════════
./ssh-ssl.sh;
clear;
echo -e "${OKEY} Script Successfull Installed";

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -rf /root/setup.sh
sleep 3
reboot
