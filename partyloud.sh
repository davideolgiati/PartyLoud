#!/usr/bin/env bash

# Copyright (C) 2019 THO
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# UI FUNCTION
logo() {
cat << 'EOF'
  ___          _        _                _
 | _ \__ _ _ _| |_ _  _| |   ___ _  _ __| |
 |  _/ _` | '_|  _| || | |__/ _ \ || / _` |
 |_| \__,_|_|  \__|\_, |____\___/\_,_\__,_|
                   |__/        Coded by THO


A simple tool to do several http request and
simulate navigation

This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to
redistribute it under certain conditions.

17/03/2019

EOF
}

DisplayHelp() {
cat << 'EOF'

Usage: ./partyloud.sh [options...]

-l --url-list     read URL list from specified FILE
-b --blocklist    read blocklist from specified FILE
-p --http-proxy   set a HTTP proxy
-s --https-proxy  set a HTTPS proxy
-h --help         dispaly this help

EOF
}

center() {
    local -r Word="${1}"
    shift
    printf "%*s" "$(( (${#Word} - $(tput cols)) / 2))" " "
    echo -ne "${Word}"
}

clearLines() {
    local -r TotalLines="${1}"
    shift
    for ((x=1; x<="${TotalLines}"; x++)); do
        if [[ "${x}" != "${TotalLines}" ]]; then
            tput cuu1
        fi
        tput el1
        echo -ne "\r"
    done
}

progress() {
    clearLines 1
    if [[ "${#}" == 2 ]]; then
        echo -ne "${1} [${2}]"
    else
        echo -ne "${1}"
    fi
}

proxySetup() {
    local -r Input="${1}"
    local Tmp=""
    local Proto="$2"

    if [[ "${Input}" == http://* ]] ; then
        Proto="http"
        Tmp="${Input:7}"
    elif [[ "${Input}" == https://* ]] ; then
        Proto="https"
        Tmp="${Input:8}"
    else
        Tmp="${input}"
    fi

    local -r Ip="${Tmp%%:*}"
    local -r Port="${Tmp##*:}"
    local CurlOptions=""

    if (echo >/dev/tcp/"${Ip}"/"${Port}") &>/dev/null; then

        if [[ "${Proto}" == "https" ]]; then
            CurlOptions=" --proxy-insecure"
        fi

        CurlOptions="${CurlOptions} --proxy ${Proto}://${Ip}:${Port}"
    fi

    echo "${CurlOptions}"
}

generateUserAgent() {
    local -r Win=( "10.0"  # Win10
                   "6.3"   # Win 8.1
                   "6.2"   # Win 8
                   "6.1" ) # Win 7

    local -r Mac=( "10_14" "10_14_1" "10_14_2" "10_14_3"
                   "10_14_4" "10_14_5" "10_14_6"         # Mojave
                   "10_13" "10_13_1" "10_13_2" "10_13_3"
                   "10_13_4" "10_13_5" "10_13_6"         # High Sierra
                   "10_12" "10_12_1" "10_12_2" "10_12_3"
                   "10_12_4" "10_12_5" "10_12_6"         # Sierra
                   "10_11" "10_11_1" "10_11_2" "10_11_3"
                   "10_11_4" "10_11_5" "10_11_6")        # El Capitan

    local UserAgent="Mozilla/5.0 "

    local OS="$(( RANDOM % 3 + 1 ))"
    local -r Bit="$(( RANDOM % 2 ))"

    if [[ "${OS}" == 1 ]]; then
        # Windows
        os="${Win[$(( RANDOM % ${#Win[@]} ))]}"
        if [[ "${Bit}" == 0 ]]; then
            # 32bit
            UserAgent+="(Windows NT ${OS}"
        else
            # 64bit
            UserAgent+="(Windows NT ${OS}; Win64; x64"
        fi
    elif [[ "${OS}" == 2 ]]; then
        # MacOS
        os="${Mac[$(( RANDOM % ${#Mac[@]} ))]}"
        UserAgent+="(Macintosh; Intel Mac OS X ${OS}"
    else
        # Linux
        if [[ "${Bit}" == 0 ]]; then
            # 32bit
            UserAgent+="(X11; Linux i686"
        else
            # 64bit
            UserAgent+="(X11; Linux x86_64"
        fi
    fi

    local -r Browser="$(( RANDOM % 2 ))"
    local Ver=""

    if [[ "${Browser}" == 1 ]]; then
        # Firefox
        local -r FF=( "50.0" "50.0.1" "50.0.2" "50.1.0"
                      "51.0" "51.0.1" "51.0.2" "51.0.3"
                      "52.0" "52.0.1" "52.0.2"
                      "53.0" "53.0.1" "53.0.2" "53.0.3"
                      "54.0" "54.0.1"
                      "55.0" "55.0.1" "55.0.2" "55.0.3"
                      "56.0" "56.0.1" "56.0.2"
                      "57.0" "57.0.1" "57.0.2" "57.0.3" "57.0.4"
                      "58.0" "58.0.1" "58.0.2"
                      "59.0" "59.0.1" "59.0.2" "59.0.3"
                      "60.0" "60.0.1" "60.0.2"
                      "61.0" "61.0.1" "61.0.2"
                      "62.0" "62.0.1" "62.0.2" "62.0.3"
                      "63.0" "63.0.1" "63.0.2" "63.0.3"
                      "64.0" "64.0.1" "64.0.2"
                      "65.0" "65.0.1" "65.0.2"
                      "66.0" )
        Ver="${FF[$(( RANDOM % ${#FF[@]} ))]}"
        UserAgent+="; rv:${Ver}) Gecko/20100101 Firefox/${Ver}"
    else
        # Chrome
        local -r CH=( "56.0.2924" "57.0.2987" "58.0.3029"
                      "59.0.3071" "60.0.3112" "61.0.3163"
                      "62.0.3202" "63.0.3239" "64.0.3282"
                      "65.0.3325" "66.0.3359" "67.0.3396"
                      "68.0.3440" "69.0.3497" "70.0.3538"
                      "71.0.3578" "72.0.3626" "73.0.3683" )
        Ver="${CH[$(( RANDOM % ${#CH[@]} ))]}"
        UserAgent+=") AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${Ver} Safari/537.36"
    fi

    echo "${UserAgent}"
}

getLock() {
    while ! mkdir /tmp/partyloud.lock 2>/dev/null; do
        sleep 0.2
    done
}

freeLock() {
    rm -fr /tmp/partyloud.lock
}


stop() {
    for PID in "${PIDS[@]}"; do
        progress "[+] Terminating HTTP Engines ..." "pid: ${PID}"
        kill -9 "${PID}"
        wait "${PID}" 2>/dev/null
    done
}

filter() {
    local Urls="${1}"
    if [[ "${Urls}" != "" ]]; then
        for FILTER in "${BLOCKLIST}"; do
            Urls="$(grep -iv "${FILTER}" <<< "${Urls}")"
        done
    fi
    echo "${Urls}"
}

SWCheck() {
    local -r SW=( "echo"
                  "curl"
                  "grep"
                  "sed"
                  "awk"
                  "wc"
                  "sort"
                  "uniq"
                  "kill"
                  "wait"
                  "rm"
                  "mkdir"
                  "printf"
                  "bc"
                )
    for COMMAND in "${SW[@]}"; do
        if [[ $TEST == true ]]; then
            if [[ $(command -v "$COMMAND") ]]; then
                tput bold
                echo "[+] $COMMAND Found!"
                tput sgr0
            else
                tput bold
                tput setaf 1
                echo "[!] $COMMAND not Found!!"
                tput sgr0
                TEST=false
            fi
        fi
    done
}

Engine() {
    sleep "$(( RANDOM % 5 ))"
    local Url="${1}"
    local Alt="${3}"
    local Res=""
    local Size=0
    local -r UrlRegex='(https|http)://[A-Za-z0-9_|.]*(/([^\.\"?:;,#\<\>=% ]*(.html)?)*)'
    while true; do
        getLock
        local Cmd=( "curl"
                    "--compressed" # Ask to server to compress response
                    "--header" "Accept: text/html" # Filter out everything but hml
                    "--max-time" "60" # Max wait time adjusted to 60s
                    "--location" # Follow redirect
                    "--user-agent" "${2}" # Specify user agent
                    "--write-out" "'%{http_code}'" # Show HTTP response code
                    "${4}" # Proxy options
                    "${Url}" )
        local op=$("${Cmd[@]}" 2>&1)
        if [[ -n $op ]]; then
            Res="$op"
        else
            Res=""
        fi
        freeLock

        echo -ne "[*] ${Url:0:60}"
        if [[ "${#Url}" -gt 60 ]]; then
            echo -ne "... "
            tput cuf 6
        else
            tput cuf "$(( 70 - ${#Url} ))"
        fi

        echo " ${Res:(-5)}"
        if [[ "${Res}" != "" ]] && [[ "${Res:(-5)}" == "'200'" ]]; then
            Res="$(awk -F '"' '{print $2}' <<< "${Res}")"
            Res="$(grep -Eo "${UrlRegex}" <<< "${Res}" | sort | uniq)"
            Res="$(filter "${Res}")"
            Size="$(wc -l <<< "${Res}")"
            if [[ "${Size}" -gt 3 ]]; then
                Alt="${Url}"
                Num="$(( RANDOM % $(( Size - 1 )) + 1 ))"
                Url="$(sed "${Num}q;d" <<< "${Res}")" # Random Link
                if [[ $WAIT == true ]]; then
                    Words="0.$(( RANDOM % 9999999 ))"
                    sleep "$(echo "$(( RANDOM % 160 + 40)) * $Words" | bc)"
                fi
            else
                Url="${Alt}"
                Alt="${3}"
            fi
        else
            Url="${Alt}"
            Alt="${3}"
        fi
    done
}

main() {
    local UrlList="partyloud.conf"
    local BLOCKLIST="badwords"
    local ProxyOpt=""
    local WAIT=true

    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -n | --no-wait )
                WAIT=false
                ;;
            -l | --url-list )
                shift
                if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
                    if [[ -e "$1" ]]; then
                        UrlList="$1"
                    else
                        tput bold
                        echo "[!] a file named \"$1\" does not exist"
                        tput sgr0
                        DisplayHelp
                        exit 1
                    fi
                else
                    DisplayHelp
                    exit 1
                fi
                ;;
            -b | --blocklist )
                shift
                if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
                    if [[ -e "$1" ]]; then
                        BLOCKLIST="$1"
                    else
                        tput bold
                        echo "[!] a file named \"$1\" does not exist"
                        tput sgr0
                        DisplayHelp
                        exit 1
                    fi
                else
                    DisplayHelp
                    exit 1
                fi
                ;;
            -p | --http-proxy )
                shift
                if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
                    ProxyOpt="$(proxySetup "$1" "http")"
                else
                    DisplayHelp
                    exit 1
                fi
                ;;
            -s | --https-proxy )
                shift
                if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
                    ProxyOpt="$(proxySetup "$1" "https")"
                else
                    DisplayHelp
                    exit 1
                fi
                ;;
            -h | --help )
                DisplayHelp
                exit 0
                ;;
            *)
                DisplayHelp
                exit 1
                ;;
        esac
        shift
    done

    export WAIT
    export BLOCKLIST

    echo "[+] Using $UrlList as URL List"
    echo "[+] Using $BLOCKLIST as Blocklist"
    if [[ "$ProxyOpt" != "" ]]; then
        echo "[+] Proxy is in use"
    fi
    echo -ne "\n"

    UrlList="$(< "$UrlList")"
    BLOCKLIST="$(< "$BLOCKLIST")"

    local TEST=true
    export TEST
    SWCheck
    if [[ "$TEST" == true ]]; then
        echo -ne "\n"
        echo -ne "[+] Testing Internet Connection ..."
        if (echo >/dev/tcp/www.google.com/80) &>/dev/null; then
            clearLines 1
            echo -ne "[+] Internet Connection Available!\n\n"

            declare -a PIDS

            export PIDS

            trap stop SIGINT
            trap stop SIGTERM
            trap stop EXIT

            local CurrentUrl=""
            local AltUrl="https://hackernoon.com"

            local ThreadCount="0"

            getLock

            for CurrentUrl in $UrlList; do
                if [[ $ThreadCount -lt 10 ]]; then
                    progress "[+] Starting HTTP Engine ($CurrentUrl) ... "
                    Engine "${CurrentUrl}" "$(generateUserAgent)" "${AltUrl}" "${ProxyOpt}" &
                    PIDS+=("$!")
                    sleep 0.4
                    AltUrl="${CurrentUrl}"
                    ThreadCount="$(( ThreadCount + 1))"
                fi
            done

            freeLock

            clearLines 1
            tput bold
            echo -ne "[+] HTTP Engines Started!\n"
            tput sgr0

            echo -ne "\n\n"

            tput bold
            center "[ PRESS ENTER TO STOP ]"
            tput sgr0

            echo -ne "\n\n\n"
            read -r _

            stop

            clearLines 1
            tput bold
            echo -ne "[+] HTTP Engines Stopped!\n\n"
            tput sgr0

        else
            clearLines 1
            tput bold
            tput setaf 1
            echo "[!] Unable to Connect to Network!"
            tput sgr0
        fi
    fi
}

clear
logo

rm -fr /tmp/partyloud.lock

main "${@}"

exit 0
