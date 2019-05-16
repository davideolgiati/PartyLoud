#! /bin/bash

checkURL() { # VERY ALPHA
    local -r URLToTest="${1}"
    if [[ ${URLToTest} =~ ^(http:\/\/|https:\/\/)([a-z0-9]{1,20}\.){1,2}[a-z]{2,5}(:(80|443))?(\/[a-z0-9]{1,20}){0,10}(\/[a-z0-9]{0,20}(\.html)?)?$ ]]; then
        echo "${URLToTest}"
    else
        echo ""
    fi
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

Engine() {
    sleep "$(( RANDOM % 5 ))"
    local Url="${1}"
    local Alt="${3}"
    local Res=""
    local Size=0
    local -r UrlRegex='(https|http)://[A-Za-z0-9_|.]*(/([^\.\"?:;,#\<\>=% ]*(.html)?)*)'
    local DNSQuery=""

    while true; do
        getLock
        DNSQuery="$(generateDNSQuery "")"
        local Cmd=( "curl"
                    "--compressed" # Ask to server to compress response
                    "--header" "Accept: text/html" # Filter out everything but hml
                    "--max-time" "60" # Max wait time adjusted to 60s
                    "--location" # Follow redirect
                    "--user-agent" "${2}" # Specify user agent
                    "--write-out" "'%{http_code}'" # Show HTTP response code
                    "$DNSQuery" # DNS Options
                    "${4}" # Proxy options
                    "${Url}" )
        #echo "${Cmd[@]}"
        local op=$("${Cmd[@]}" 2>&1)
        if [[ -n $op ]]; then
            Res="$op"
        else
            Res=""
        fi

        echo -ne "[*] ${Url:0:60}"
        if [[ "${#Url}" -gt 60 ]]; then
            echo -ne "... "
            tput cuf 6
        else
            tput cuf "$(( 70 - ${#Url} ))"
        fi

        echo " ${Res:(-5)}"
        #echo "${Res}" -- DEBUG
        if [[ "${Res}" != "" ]] && [[ "${Res:(-5)}" == "'200'" ]]; then
            Res="$(awk -F '"' '{print $2}' <<< "${Res}")"
            Res="$(grep -Eo "${UrlRegex}" <<< "${Res}" | sort | uniq)"
            Res="$(filter "${Res}")"
            Size="$(echo $(wc -l <<< "${Res}") | cut -d " " -f1)"
            if [[ "${Size}" -gt 3 ]]; then
                Alt="${Url}"
                Num="$(( RANDOM % $(( Size - 1 )) + 1 ))"
                Url="$(sed "${Num}q;d" <<< "${Res}")" # Random Link
                freeLock
                if [[ $WAIT == true ]]; then
                    Words="0.$(( RANDOM % 9999999 ))"
                    sleep "$(echo "$(( RANDOM % 160 + 40)) * $Words" | bc)"
                fi
            else
                Url="${Alt}"
                Alt="${3}"
                freeLock
            fi
        else
            Url="${Alt}"
            Alt="${3}"
            freeLock
        fi
    done
}
