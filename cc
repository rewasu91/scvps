#!/bin/bash
#Script Add Trojan

red='\e[38;1;31m'
green='\e[38;1;32m'
yellow='\e[38;1;33m'
blue='\e[38;5;27m'
purple='\e[38;5;166m'
WhiteB="\e[5;37m"
BlueCyan="\e[38;1;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
bgPutih="\e[1;47;30m"
bgMerah="\e[1;41;37m"
white='\e[0;37m'
plain='\e[0m'
Suffix="\033[0m"
NC='\e[0m'
keatas="${BlueCyan}│${plain}"
ON="${green}ON${plain}"
OFF="${red}OFF${plain}"
jari="${yellow}☞${plain}"

function laneTop() {
  echo -e "${BlueCyan}┌─────────────────────────────────────────────────┐${plain}"
}
function laneBot() {
  echo -e "${BlueCyan}└─────────────────────────────────────────────────┘${plain}"
}
function laneTop1() {
  echo -e "   ${BlueCyan}┌───────────────────────────────────────────┐${plain}"
}
function laneBot1() {
  echo -e "   ${BlueCyan}└───────────────────────────────────────────┘${plain}"
}
function laneTop2() {
  echo -e "     ${BlueCyan}┌───────────────────────────────────────┐${plain}"
}
function laneBot2() {
  echo -e "     ${BlueCyan}└───────────────────────────────────────┘${plain}"
}
function LOGO() {
	laneTop
	echo -e "${keatas} ${bgPutih}              AUTOSKRIP KAIZENVPS              ${plain} ${keatas}"
	laneBot
	echo -e ""
}

function Credit_KaizenVPS() {
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih} TERIMA KASIH KERANA MENGGUNAKAN AUTOSKRIP INI ${plain} ${keatas}"
	laneBot
	echo -e ""
}

LOGO
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "${bgPutih}                 TROJAN USER LOGIN                 ${plain}"
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "    ${yellow}USERNAME          EXP DATE          STATUS${plain}";
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "    fiezlan	       Aug 28, 2023      Online"
echo -e "    adsadfs	       Aug 28, 2023      Online"
echo -e "    eqgfaes	       Aug 28, 2023      Online"
echo -e "    rwgdgdas	       Aug 28, 2023      Online"
Credit_KaizenVPS
echo -e ""
echo -e ""
LOGO
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "${bgMerah}                 TROJAN USER LOGIN                 ${plain}"
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "    ${yellow}USERNAME          EXP DATE          STATUS${plain}";
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
echo -e "    fiezlan	       Aug 28, 2023      Online"
echo -e "    adsadfs	       Aug 28, 2023      Online"
echo -e "    eqgfaes	       Aug 28, 2023      Online"
echo -e "    rwgdgdas	       Aug 28, 2023      Online"
Credit_KaizenVPS
echo -e ""
