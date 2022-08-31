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
export VERSION="1.0";
export EDITION="Stable";
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

# ════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang
# ════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    rm -f /root/menu-setup.sh;
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
    clear
    echo -e "${ERROR} JQ Packages Not installed";
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

# ═════════════
# // Clear Data
# ═════════════
clear;

# ═══════════════════
# // Downloading Menu
# ═══════════════════+

export Layanan='trojan';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='vmess';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='vless';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ss';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/${Layanan}log "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}log.sh"; chmod +x /usr/local/sbin/${Layanan}log;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ssh';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='wg';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/chk${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/chk${Layanan}.sh"; chmod +x /usr/local/sbin/chk${Layanan};
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='socks';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='http';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

export Layanan='ssr';
wget -q -O /usr/local/sbin/${Layanan}-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/menu.sh"; chmod +x /usr/local/sbin/${Layanan}-menu;
wget -q -O /usr/local/sbin/add${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/add${Layanan}.sh"; chmod +x /usr/local/sbin/add${Layanan};
wget -q -O /usr/local/sbin/del${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/del${Layanan}.sh"; chmod +x /usr/local/sbin/del${Layanan};
wget -q -O /usr/local/sbin/trial${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/trial${Layanan}.sh"; chmod +x /usr/local/sbin/trial${Layanan};
wget -q -O /usr/local/sbin/${Layanan}exp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}exp.sh"; chmod +x /usr/local/sbin/${Layanan}exp;
wget -q -O /usr/local/sbin/${Layanan}config "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}config.sh"; chmod +x /usr/local/sbin/${Layanan}config;
wget -q -O /usr/local/sbin/${Layanan}list "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/${Layanan}list.sh"; chmod +x /usr/local/sbin/${Layanan}list;
wget -q -O /usr/local/sbin/renew${Layanan} "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/${Layanan}/renew${Layanan}.sh"; chmod +x /usr/local/sbin/renew${Layanan};

# // Panel Tools
wget -q -O /usr/local/sbin/panel-add-http "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-http.sh"; chmod +x /usr/local/sbin/panel-add-http;
wget -q -O /usr/local/sbin/panel-add-ssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-ssh.sh"; chmod +x /usr/local/sbin/panel-add-ssh;
wget -q -O /usr/local/sbin/panel-add-wg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-wg.sh"; chmod +x /usr/local/sbin/panel-add-wg;
wget -q -O /usr/local/sbin/panel-add-trojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-trojan.sh"; chmod +x /usr/local/sbin/panel-add-trojan;
wget -q -O /usr/local/sbin/panel-add-vmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-vmess.sh"; chmod +x /usr/local/sbin/panel-add-vmess;
wget -q -O /usr/local/sbin/panel-add-vless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-vless.sh"; chmod +x /usr/local/sbin/panel-add-vless;
wget -q -O /usr/local/sbin/panel-add-socks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-socks.sh"; chmod +x /usr/local/sbin/panel-add-socks;
wget -q -O /usr/local/sbin/panel-add-ss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-ss.sh"; chmod +x /usr/local/sbin/panel-add-ss;

# // Other
wget -q -O /usr/local/sbin/menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/menu.sh"; chmod +x /usr/local/sbin/menu;
wget -q -O /usr/local/sbin/lcn-change "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/change-lcn.sh"; chmod +x /usr/local/sbin/lcn-change;
wget -q -O /usr/local/sbin/speedtest "https://releases.sshwsvpn.me/vpn-script/Resource/Core/speedtest"; chmod +x /usr/local/sbin/speedtest;
wget -q -O /usr/local/sbin/ram-usage "https://releases.sshwsvpn.me/vpn-script/Resource/Core/ram-usage.sh"; chmod +x /usr/local/sbin/ram-usage;
wget -q -O /usr/local/sbin/autokill-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/pro/autokill/menu.sh"; chmod +x /usr/local/sbin/autokill-menu;
wget -q -O /usr/local/sbin/autoexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/autoexp.sh"; chmod +x /usr/local/sbin/autoexp;
wget -q -O /usr/local/sbin/autobackup "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/backup.sh"; chmod +x /usr/local/sbin/autobackup;
wget -q -O /usr/local/sbin/backup "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/backup.sh"; chmod +x /usr/local/sbin/backup;
wget -q -O /usr/local/sbin/restore "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/restore.sh"; chmod +x /usr/local/sbin/restore;
wget -q -O /usr/local/sbin/change-port "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/other/port-change.sh"; chmod +x /usr/local/sbin/change-port;
wget -q -O /usr/local/sbin/clearlog "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/clearlog.sh"; chmod +x /usr/local/sbin/clearlog;
wget -q -O /usr/local/sbin/infonya "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/info.sh"; chmod +x /usr/local/sbin/infonya;
wget -q -O /usr/local/sbin/vpnscript "https://raw.githubusercontent.com/rewasu91/scvps/main/Setup/script-version.sh"; chmod +x /usr/local/sbin/vpnscript

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f menu-setup.sh
