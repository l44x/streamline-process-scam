#!/bin/bash
#Author: L44x
# streamline-process-scam

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo... :) \n${endColour}"
    exit 0
}

function banner() {
    echo -e "\n\n\n ${blueColour}__      .____     _____     _____ ____  ___       __${endColour} "
    echo -e " ${blueColour}\ \     |    |      /  |  |   /  |  |\   \/  /     / /${endColour} "
    echo -e " ${redColour} \ \    |    |     /   |  |_ /   |  |_\     /     / /${endColour}           ${purpleColour}👑${endColour} ${yellowColour}GitHub${endColour} ${redColour}>${endColour} ${whiteColour}https://${endColour}${redColour}github.com/${endColour}${whiteColour}l44x${endColour}"
    echo -e " ${redColour} / /    |    |___ /    ^   //    ^   //     \     \ \ ${endColour} "
    echo -e " ${blueColour}/_/     |_______ \\____   | \____   |/___/\  \      \_\ ${endColour}"
    echo -e " ${blueColour}                \/     |__|      |__|      \_/         ${endColour}"
    echo -e "                                                       "  
    echo -e "                          [${redColour}███${endColour}${whiteColour}███${endColour}${redColour}███${endColour}] \n\n\n"
}

function helpPanel(){
  clear; banner
  echo -e "${purpleColour}=======================================================================${endColour}"
  echo -e "\t\t${yellowColour}[*]${endColour}${grayColour} Uso: ./bash-scripting06.sh ${endColour}\n"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-a]${endColour} ${redColour}|${endColour}${greenColour} Mandar la ip de la maquina victima.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-h]${endColour} ${redColour}|${endColour}${greenColour} Mostrar el panel de ayuda.${endColour}"
  echo -e "\n\t\t\t${yellowColour}[👑]${endColour}${grayColour} By: L44x ${endColour}"
  
  echo -e "${purpleColour}=======================================================================${endColour}\n\n"
}

function openProcessCommands(){
    echo -e "Terminal interactive $getIpScanner"
    commandExecuteSendPing
    commandExecuteSendNmapSearchPorts
    commandExecuteSearchServicesOpen
    commandExecuteWhatweb
}

function commandExecuteSendPing(){
    clear;
    read -p "Verificar conexion maquina victima (YES/NO): " commandToExecute
    if [ "$(echo $commandToExecute)" == "YES" ]; then
        echo -e "executing..."
        ping -c 1 $getIpScanner -R > getConection.tmp 2>/dev/null
        if [ "$(cat getConection.tmp | grep "transmitted" | cut -d, -f2)" == " 1 received" ]; then
            echo -e "La maquina victima se encuentra activa."
            rm getConection.tmp 2>/dev/null
        else
            echo -e "La maquina victima no esta activa."
        fi
    fi
} 

function commandExecuteSendNmapSearchPorts(){
    clear;
    echo -e "Scanning..."
    echo -e $getIpScanner
    nmap -p- -sS --min-rate 5000 --open -vvv -n -Pn $getIpScanner -oG allPorts > /dev/null 2>&1;
    echo -e "\n Hemos mantenido el scaneo de puertos abiertos en allPorts"
    echo -e "Los puertos abiertos para $getIpScanner"
    ports="$(cat allPorts | grep -Eo '([0-9]+)/open/' | cut -d '/' -f 1 | grep -v "%" | tr '\n' ',' | sed 's/,$//' | grep -v "%")"           # ports
}

function commandExecuteSearchServicesOpen(){
    clear;
    echo -e "Scanning Services for OpenPorts..."
    echo -e "$ports"
    nmap -sCV -p "$ports" $getIpScanner -oN targeted 2>/dev/null
}

function commandExecuteWhatweb(){
    clear;
    echo -e "Whatweb executing..."
    whatweb http://$getIpScanner:80 > WhatwebContent

    if [ "$(cat targeted | grep "follow" | echo $? 2>/dev/null)"  ==  0 ]; then
        echo -e "Necesitas agregar la direccion IP a /etc/hosts" 2>/dev/null
    else
        whatweb http://$getIpScanner:80 > WhatwebContent
    fi
}

# Parametros funcionales.
getIpScanner=""

while getopts ":a:h" arg; do # Parameters.
    case $arg in
        a) getIpScanner=$OPTARG;;
        h) helpPanel;;
    esac
done

if [ "$(echo ${getIpScanner})" ]; then # ./script.sh -a
    clear;openProcessCommands
fi
