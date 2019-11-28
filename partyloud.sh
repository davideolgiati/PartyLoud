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

main() {
    # path to file containg base urls
    local UrlList="partyloud.conf"
    # path to file containg string to be filtered
    local BLOCKLIST="badwords"
    # variable containg proxy setup option
    local ProxyOpt=""
    # service variable to regulate threads
    local WAIT=true
    # variable conating dns address
    local DNSArray=""
    # DNSArray size
    local DNSArraySize=0

    # flag parsing
    # loop until the input variable has '-' as the first charapter
    while [[ "$1" =~ ^- ]]; do
	# switch-case on the flag
	case "$1" in
	    # -n means that the user don't want the script to
	    # wait between two requests
	    -n | --no-wait )
		# basically we set WAIT to false, that's it
		WAIT=false
		;;
	    # --dns was used to specify a file containg IPs refering to DNS servers
	    # this was a bad idea becouse the goal of the script is to hide the real user
	    # navigation. Using different o random DNSes is a bad practice, here's why.
	    # Think yourself as an hacker sniffing the traffic coming from one pc over
	    # the network.
	    # In the "bad choise" scenario You'll see a lot of traffic direct to random
	    # DNSes and some traffic direct to a fixed ip. It's pretty easy to see which
	    # traffic is real and which is not.
	    -d | --dns )gggggg
		bold "[!] --dns flag was a bad idea, is now deprecated"
		bold "    please refear to the official github repository"
		exit 1
		;;
	    # --url-list is used to specify a user file contining the base urls
	    --url-list )
		shift
		if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
		    if [[ -e "$1" ]]; then
			UrlList="$1"
		    else
			bold "[!] a file named \"$1\" does not exist"
			DisplayHelp
			exit 1
		    fi
		else
		    DisplayHelp
		    exit 1
		fi
		;;
	    -l)
		bold "[!] please use --url-list instead of -l"
		exit 1
		;;
	    # --blocklist is used to specify a user file containg a custom
	    # filter rules set
	    -b | --blocklist )
		shift
		if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
		    if [[ -e "$1" ]]; then
			BLOCKLIST="$1"
		    else
			bold "[!] a file named \"$1\" does not exist"
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
    export DNSList
    export DNSArraySize

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
