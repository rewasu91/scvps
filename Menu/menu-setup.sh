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

# ══════════════════════════
# // Downloading Menu Trojan
# ══════════════════════════
wget -q -O /usr/local/sbin/trojan-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/menu.sh"; chmod +x /usr/local/sbin/trojan-menu;
wget -q -O /usr/local/sbin/addtrojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/addtrojan.sh"; chmod +x /usr/local/sbin/addtrojan;
wget -q -O /usr/local/sbin/deltrojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/deltrojan.sh"; chmod +x /usr/local/sbin/deltrojan;
wget -q -O /usr/local/sbin/trialtrojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/trialtrojan.sh"; chmod +x /usr/local/sbin/trialtrojan;
wget -q -O /usr/local/sbin/trojanexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/trojanexp.sh"; chmod +x /usr/local/sbin/trojanexp;
wget -q -O /usr/local/sbin/trojanconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/trojanconfig.sh"; chmod +x /usr/local/sbin/trojanconfig;
wget -q -O /usr/local/sbin/trojanlist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/trojanlist.sh"; chmod +x /usr/local/sbin/trojanlist;
wget -q -O /usr/local/sbin/chktrojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/chktrojan.sh"; chmod +x /usr/local/sbin/chktrojan;
wget -q -O /usr/local/sbin/trojanlog "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/trojanlog.sh"; chmod +x /usr/local/sbin/trojanlog;
wget -q -O /usr/local/sbin/renewtrojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/trojan/renewtrojan.sh"; chmod +x /usr/local/sbin/renewtrojan;

# ═════════════════════════
# // Downloading Menu Vmess
# ═════════════════════════
wget -q -O /usr/local/sbin/vmess-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/menu.sh"; chmod +x /usr/local/sbin/vmess-menu;
wget -q -O /usr/local/sbin/addvmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/addvmess.sh"; chmod +x /usr/local/sbin/addvmess;
wget -q -O /usr/local/sbin/delvmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/delvmess.sh"; chmod +x /usr/local/sbin/delvmess;
wget -q -O /usr/local/sbin/trialvmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/trialvmess.sh"; chmod +x /usr/local/sbin/trialvmess;
wget -q -O /usr/local/sbin/vmessexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/vmessexp.sh"; chmod +x /usr/local/sbin/vmessexp;
wget -q -O /usr/local/sbin/vmessconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/vmessconfig.sh"; chmod +x /usr/local/sbin/vmessconfig;
wget -q -O /usr/local/sbin/vmesslist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/vmesslist.sh"; chmod +x /usr/local/sbin/vmesslist;
wget -q -O /usr/local/sbin/chkvmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/chkvmess.sh"; chmod +x /usr/local/sbin/chkvmess;
wget -q -O /usr/local/sbin/vmesslog "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/vmesslog.sh"; chmod +x /usr/local/sbin/vmesslog;
wget -q -O /usr/local/sbin/renewvmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vmess/renewvmess.sh"; chmod +x /usr/local/sbin/renewvmess;

# ═════════════════════════
# // Downloading Menu Vless
# ═════════════════════════
wget -q -O /usr/local/sbin/vless-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/menu.sh"; chmod +x /usr/local/sbin/vless-menu;
wget -q -O /usr/local/sbin/addvless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/addvless.sh"; chmod +x /usr/local/sbin/addvless;
wget -q -O /usr/local/sbin/delvless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/delvless.sh"; chmod +x /usr/local/sbin/delvless;
wget -q -O /usr/local/sbin/trialvless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/trialvless.sh"; chmod +x /usr/local/sbin/trialvless;
wget -q -O /usr/local/sbin/vlessexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/vlessexp.sh"; chmod +x /usr/local/sbin/vlessexp;
wget -q -O /usr/local/sbin/vlessconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/vlessconfig.sh"; chmod +x /usr/local/sbin/vlessconfig;
wget -q -O /usr/local/sbin/vlesslist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/vlesslist.sh"; chmod +x /usr/local/sbin/vlesslist;
wget -q -O /usr/local/sbin/chkvless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/chkvless.sh"; chmod +x /usr/local/sbin/chkvless;
wget -q -O /usr/local/sbin/vlesslog "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/vlesslog.sh"; chmod +x /usr/local/sbin/vlesslog;
wget -q -O /usr/local/sbin/renewvless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/vless/renewvless.sh"; chmod +x /usr/local/sbin/renewvless;

# ═══════════════════════════════
# // Downloading Menu Shadowsocks
# ═══════════════════════════════
wget -q -O /usr/local/sbin/ss-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/menu.sh"; chmod +x /usr/local/sbin/ss-menu;
wget -q -O /usr/local/sbin/addss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/addss.sh"; chmod +x /usr/local/sbin/addss;
wget -q -O /usr/local/sbin/delss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/delss.sh"; chmod +x /usr/local/sbin/delss;
wget -q -O /usr/local/sbin/trialss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/trialss.sh"; chmod +x /usr/local/sbin/trialss;
wget -q -O /usr/local/sbin/ssexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/ssexp.sh"; chmod +x /usr/local/sbin/ssexp;
wget -q -O /usr/local/sbin/ssconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/ssconfig.sh"; chmod +x /usr/local/sbin/ssconfig;
wget -q -O /usr/local/sbin/sslist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/sslist.sh"; chmod +x /usr/local/sbin/sslist;
wget -q -O /usr/local/sbin/chkss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/chkss.sh"; chmod +x /usr/local/sbin/chkss;
wget -q -O /usr/local/sbin/sslog "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/sslog.sh"; chmod +x /usr/local/sbin/sslog;
wget -q -O /usr/local/sbin/renewss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ss/renewss.sh"; chmod +x /usr/local/sbin/renewss;

# ═══════════════════════
# // Downloading Menu SSH
# ═══════════════════════
wget -q -O /usr/local/sbin/ssh-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/menu.sh"; chmod +x /usr/local/sbin/ssh-menu;
wget -q -O /usr/local/sbin/addssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/addssh.sh"; chmod +x /usr/local/sbin/addssh;
wget -q -O /usr/local/sbin/pass-ssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/pass-ssh"; chmod +x /usr/local/sbin/pass-ssh;
wget -q -O /usr/local/sbin/delssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/delssh.sh"; chmod +x /usr/local/sbin/delssh;
wget -q -O /usr/local/sbin/trialssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/trialssh.sh"; chmod +x /usr/local/sbin/trialssh;
wget -q -O /usr/local/sbin/sshexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/sshexp.sh"; chmod +x /usr/local/sbin/sshexp;
wget -q -O /usr/local/sbin/sshconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/sshconfig.sh"; chmod +x /usr/local/sbin/sshconfig;
wget -q -O /usr/local/sbin/sshlist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/sshlist.sh"; chmod +x /usr/local/sbin/sshlist;
wget -q -O /usr/local/sbin/chkssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/chkssh.sh"; chmod +x /usr/local/sbin/chkssh;
wget -q -O /usr/local/sbin/renewssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssh/renewssh.sh"; chmod +x /usr/local/sbin/renewssh;

# ═════════════════════════════
# // Downloading Menu Wireguard
# ═════════════════════════════
wget -q -O /usr/local/sbin/wg-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/menu.sh"; chmod +x /usr/local/sbin/wg-menu;
wget -q -O /usr/local/sbin/addwg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/addwg.sh"; chmod +x /usr/local/sbin/addwg;
wget -q -O /usr/local/sbin/delwg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/delwg.sh"; chmod +x /usr/local/sbin/delwg;
wget -q -O /usr/local/sbin/trialwg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/trialwg.sh"; chmod +x /usr/local/sbin/trialwg;
wget -q -O /usr/local/sbin/wgexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/wgexp.sh"; chmod +x /usr/local/sbin/wgexp;
wget -q -O /usr/local/sbin/wgconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/wgconfig.sh"; chmod +x /usr/local/sbin/wgconfig;
wget -q -O /usr/local/sbin/wglist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/wglist.sh"; chmod +x /usr/local/sbin/wglist;
wget -q -O /usr/local/sbin/chkwg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/chkwg.sh"; chmod +x /usr/local/sbin/chkwg;
wget -q -O /usr/local/sbin/renewwg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/wg/renewwg.sh"; chmod +x /usr/local/sbin/renewwg;

# ═════════════════════════
# // Downloading Menu Socks
# ═════════════════════════
wget -q -O /usr/local/sbin/socks-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/menu.sh"; chmod +x /usr/local/sbin/socks-menu;
wget -q -O /usr/local/sbin/addsocks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/addsocks.sh"; chmod +x /usr/local/sbin/addsocks;
wget -q -O /usr/local/sbin/delsocks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/delsocks.sh"; chmod +x /usr/local/sbin/delsocks;
wget -q -O /usr/local/sbin/trialsocks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/trialsocks.sh"; chmod +x /usr/local/sbin/trialsocks;
wget -q -O /usr/local/sbin/socksexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/socksexp.sh"; chmod +x /usr/local/sbin/socksexp;
wget -q -O /usr/local/sbin/socksconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/socksconfig.sh"; chmod +x /usr/local/sbin/socksconfig;
wget -q -O /usr/local/sbin/sockslist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/sockslist.sh"; chmod +x /usr/local/sbin/sockslist;
wget -q -O /usr/local/sbin/renewsocks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/socks/renewsocks.sh"; chmod +x /usr/local/sbin/renewsocks;

# ════════════════════════
# // Downloading Menu HTTP
# ════════════════════════
wget -q -O /usr/local/sbin/http-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/menu.sh"; chmod +x /usr/local/sbin/http-menu;
wget -q -O /usr/local/sbin/addhttp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/addhttp.sh"; chmod +x /usr/local/sbin/addhttp;
wget -q -O /usr/local/sbin/delhttp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/delhttp.sh"; chmod +x /usr/local/sbin/delhttp;
wget -q -O /usr/local/sbin/trialhttp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/trialhttp.sh"; chmod +x /usr/local/sbin/trialhttp;
wget -q -O /usr/local/sbin/httpexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/httpexp.sh"; chmod +x /usr/local/sbin/httpexp;
wget -q -O /usr/local/sbin/httpconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/httpconfig.sh"; chmod +x /usr/local/sbin/httpconfig;
wget -q -O /usr/local/sbin/httplist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/httplist.sh"; chmod +x /usr/local/sbin/httplist;
wget -q -O /usr/local/sbin/renewhttp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/http/renewhttp.sh"; chmod +x /usr/local/sbin/renewhttp;

# ═══════════════════════
# // Downloading Menu SSR
# ═══════════════════════
wget -q -O /usr/local/sbin/ssr-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/menu.sh"; chmod +x /usr/local/sbin/ssr-menu;
wget -q -O /usr/local/sbin/addssr "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/addssr.sh"; chmod +x /usr/local/sbin/addssr;
wget -q -O /usr/local/sbin/delssr "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/delssr.sh"; chmod +x /usr/local/sbin/delssr;
wget -q -O /usr/local/sbin/trialssr "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/trialssr.sh"; chmod +x /usr/local/sbin/trialssr;
wget -q -O /usr/local/sbin/ssrexp "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/ssrexp.sh"; chmod +x /usr/local/sbin/ssrexp;
wget -q -O /usr/local/sbin/ssrconfig "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/ssrconfig.sh"; chmod +x /usr/local/sbin/ssrconfig;
wget -q -O /usr/local/sbin/ssrlist "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/ssrlist.sh"; chmod +x /usr/local/sbin/ssrlist;
wget -q -O /usr/local/sbin/renewssr "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/ssr/renewssr.sh"; chmod +x /usr/local/sbin/renewssr;

# ══════════════════════════
# // Downloading Panel Tools
# ══════════════════════════
wget -q -O /usr/local/sbin/panel-add-http "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-http.sh"; chmod +x /usr/local/sbin/panel-add-http;
wget -q -O /usr/local/sbin/panel-add-ssh "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-ssh.sh"; chmod +x /usr/local/sbin/panel-add-ssh;
wget -q -O /usr/local/sbin/panel-add-wg "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-wg.sh"; chmod +x /usr/local/sbin/panel-add-wg;
wget -q -O /usr/local/sbin/panel-add-trojan "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-trojan.sh"; chmod +x /usr/local/sbin/panel-add-trojan;
wget -q -O /usr/local/sbin/panel-add-vmess "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-vmess.sh"; chmod +x /usr/local/sbin/panel-add-vmess;
wget -q -O /usr/local/sbin/panel-add-vless "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-vless.sh"; chmod +x /usr/local/sbin/panel-add-vless;
wget -q -O /usr/local/sbin/panel-add-socks "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-socks.sh"; chmod +x /usr/local/sbin/panel-add-socks;
wget -q -O /usr/local/sbin/panel-add-ss "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/panel/panel-add-ss.sh"; chmod +x /usr/local/sbin/panel-add-ss;

# ════════════════════════
# // Downloading Lain-lain
# ════════════════════════
wget -q -O /usr/local/sbin/menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/menu.sh"; chmod +x /usr/local/sbin/menu;
wget -q -O /usr/local/sbin/speedtest "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/speedtest"; chmod +x /usr/local/sbin/speedtest;
wget -q -O /usr/local/sbin/ram-usage "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/ram-usage.sh"; chmod +x /usr/local/sbin/ram-usage;
wget -q -O /usr/local/sbin/autokill-menu "https://raw.githubusercontent.com/rewasu91/scvps/main/Menu/Pro/Autokill/menu.sh"; chmod +x /usr/local/sbin/autokill-menu;
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
