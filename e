#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
blue='\033[0;34m'
ungu='\033[0;35m'
Green="\033[32m"
Red="\033[31m"
WhiteB="\e[5;37m"
BlueCyan="\e[5;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
Suffix="\033[0m"

bgPurple="\e[1;44;41m"
BlueCyan="\e[38;1;36m"
yellow='\e[38;1;33m'
red='\e[38;1;31m'
green='\e[38;1;32m'
blue='\e[38;5;27m'
ungu='\e[38;5;166m'
plain='\e[0m'
white='\e[0;37m'
keatas="${BlueCyan}│${plain}"
ON="${yellow}ON${plain}"
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


function LOGO2() {
clear
laneTop
echo -e "${keatas} ${bgPurple}              AUTOSKRIP KAIZENVPS              ${plain} ${keatas}"
laneBot
}

	
function Credit_KaizenVPS() {
	sleep 1
	echo -e ""
	echo -e " ${BlueCyan}————————————————————————————————————————"
	echo -e "      ${ungu}Terima kasih kerana menggunakan"
	echo -e "            Autoskrip KaizenVPS"
	echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
	echo -e ""
}

function LOGO() {
	clear
	echo -e ""
	echo -e " ${BlueCyan}————————————————————————————————————————"
	echo -e "|            ${ungu}Autoskrip KaizenVPS${BlueCyan}            |"
	echo -e " ————————————————————————————————————————${Suffix}"
	echo -e ""
}

LOGO2
