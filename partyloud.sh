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
	    -d | --dns )
		bold "[x] --dns flag was a bad idea, is now deprecated"
		bold "    please check the official github repository"
		exit 1
		;;
	    # --url-list is used to specify a user file contining the base urls
	    --url-list )
		# moving one step forward the first variable pointer
		shift
		# checking the falg has an arg and that the arg
		# is not an empty string
		if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
		    # the arg expected for --url-list
		    # should be a path to a valid file
		    if [[ -e "$1" ]]; then
			# if the file exists on the system than we can
			# salve his path in order to use the content later on
			UrlList="$1"
		    else
			# if the file doesn't exists on the system we must provide
			# a message to the user so he can than troubleshoot the problem
			bold "[x] while parsing the --url-list flag an error came up."
			bold "    Seems that a file named \"$1\" does not exist"
			bold "    on the system. Please double check the path to"
			bold "    the file and try using the absolute path."
			bold "    if the problem persists open an issue on"
			bold "    the official github repository"
			exit 1
		    fi
		else
		    # the user probably forgot to specify the file containg his
		    # custom base urls list, let's remind him about it
		    bold "[x] please check again the args you provided, looks"
		    bold "    like you forgot to specify a file in the --url-list option"
		    bold "    the flag must look like this : --url-list /path/to/the/file"
		    exit 1
		fi
		;;
	    # --blocklist is used to specify a user file containg a custom
	    # filter rules set
	    --blocklist )
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
	    -b)
		bold "[!] please use --blocklist instead of -b"
		exit 1
		;;
	    # --http-proxy is used to specify an http proxy server
	    -p | --http-proxy )
		shift
		if [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
		    ProxyOpt="$(proxySetup "$1" "http")"
		else
		    DisplayHelp
		    exit 1
		fi
		;;
	    # --https-proxy is used to specify an https proxy server
	    -s | --https-proxy )
		shift
		if [[ "$ProxyOpt" == "" ]] && [[ "$1" != "" ]] && [[ ! "$1" =~ ^- ]]; then
		    ProxyOpt="$(proxySetup "$1" "https")"
		else
		    if [[ "$ProxyOpt" != "" ]]; then
			bold "[!] looks like you trying use more than one proxy"
			bold "    please remove --https-proxy $1 and retry"
		    elif [[ "$1" == "" ]] || [[ "$1"  =~ ^- ]]; then
			bold "[!] looks like you forgot the proxy IP"
			bold "    please add a valid IP after --https-proxy"
			bold "    or remove the flag if you don't need it"
		    else
			bold "[!] $1 is not a valid argument for --https-proxy flag"
			bold "    please check the official github repository or"
			bold "    use the --help flag for more information"
		    fi
		    exit
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
