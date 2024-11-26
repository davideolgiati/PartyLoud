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

source src/proxy.sh          # proxySetup()
source src/ui.sh             # logo() DisplayHelp() center() clearLines() progress()
source src/tools.sh          # getLock() freeLock() SWCheck()
source src/dns.sh            # generateDNSQuery()
source src/requestsEngine.sh # generateUserAgent() stop() filter() Engine()

# global constants
readonly URL_LIST_LOCATION="urls.txt"
readonly BLOCKLIST_LOCATION="blacklist.txt"
readonly URL_LIST="$(< "$URL_LIST_LOCATION")"
readonly BLOCKLIST="$(< "$BLOCKLIST_LOCATION")"

processProxyUri(){
    readonly uri="${1}"
    readonly protocol="${2}"
    declare -n curlProxyFlags=$3

    if [[ "${uri}" == "" ]]; then
        DisplayHelp
	exit 1
    fi

    if [[ "${uri}" =~ ^- ]]; then
        DisplayHelp
	exit 1
    fi
	
    curlProxyFlags="$(proxySetup "${uri}" "${protocol}")"
}


main() {
    local curlProxyFlags=""
    local secondsBetweenRequests=true

    # flag parsing
    # loop until the input variable has '-' as the first charapter
    while [[ "$1" =~ ^- ]]; do
	# switch-case on the flag
	case "$1" in
	    -n | --no-wait )
		secondsBetweenRequests="0"
		;;
	    -p | --http-proxy )
		processProxyUri "${2}" "http" $curlProxyFlags
		shift
		;;
	    -s | --https-proxy )
		processProxyUri "${2}" "https" $curlProxyFlags
		shift
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

    echo "[+] Using $URL_LIST_LOCATION as URL List"
    echo "[+] Using $BLOCKLIST_LOCATION as Blocklist"

    if [[ "$curlProxyFlags" != "" ]]; then
	echo "[+] Proxy is in use"
    fi

    echo -ne "\n"

    SWCheck
	
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

	    for CurrentUrl in $URL_LIST_LOCATION; do
		if [[ $ThreadCount -lt 10 ]]; then
		    progress "[+] Starting HTTP Engine ($CurrentUrl) ... "
		    Engine "${CurrentUrl}" "$(generateUserAgent)" "${AltUrl}" "${curlProxyFlags}" &
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
