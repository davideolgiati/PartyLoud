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

log() {
    readonly level="${1}"
    readonly message="${2}"
    readonly currentTimestamp="$(date --utc +%FT%TZ)"

    echo -n "[${currentTimestamp}] "

    case "${level}" in
	debug)
	    echo -e "[DEBUG] ${message}"
	    ;;
	info)
	    echo -e "[INFO]  ${message}"
	    ;;
	warn)
	    echo -e "[WARN]  ${message}"
	    ;;
	error)
	    echo -ne "\033[1;31m"
	    echo -e "[ERROR] ${message}"
	    echo -ne "\033[0m"
	    ;;
    esac
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

    log debug "Using file \"$URL_LIST_LOCATION\" as url list"
    log debug "Using file \"$BLOCKLIST_LOCATION\" as blacklist"

    if [[ "$curlProxyFlags" != "" ]]; then
	log debug "Proxy configuration for curl: \"${curlProxyFlags}\""
    fi

    SWCheck
	
    log info "Testing Internet Connection"
    if (echo >/dev/tcp/www.google.com/80) &>/dev/null; then
	clearLines 1
	log info "Internet Connection Available!"

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
	log info "HTTP Engines Started!\n"

	stop
    else
	clearLines 1
	log error "[!] Unable to Connect to Network!"
    fi
}

clear
logo

rm -fr /tmp/partyloud.lock

main "${@}"

exit 0
