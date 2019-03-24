#!/bin/bash

function logo() {
    cat << "EOF"
  ___          _        _                _
 | _ \__ _ _ _| |_ _  _| |   ___ _  _ __| |
 |  _/ _` | '_|  _| || | |__/ _ \ || / _` |
 |_| \__,_|_|  \__|\_, |____\___/\_,_\__,_|
                   |__/        Coded by THO

A simple tool to do several
http request and simulate navigation
17/03/2019

EOF
}

function progress() {
    echo -ne "\r$3 [$1/$2]"
}

function Engine() {
    local URL="$1"
    local ALT="$1"
    local RES=""
    local NUM=0
    local WORDS=0;
    readonly LIST="$(cat badwords)"
    while true; do
        RES="$(curl -L -A "$USERAGENT" "$URL" 2>&1 | grep -Eo 'href="[^\"]+"' |  grep -Eo '(http|https)://[^"]+' | sort | uniq | grep -vF "$LIST")"
        if [ $? -eq 0  ] && [ "$(echo "$RES" | wc -l)" > 1 ]
        then
            NUM="$(( $RANDOM % "$(( $(echo "$RES" | wc -l) - 1 ))" + 1 ))"
            ALT="$URL"
            URL="$(echo "$RES" | sed "${NUM}q;d")" # Random Link
        else
            URL="$ALT"
            ALT="$1"
        fi
        WORDS="$(( $RANDOM % 100 + 150 ))" # Guessing words on the web page
        NUM="0.$(( $RANDOM % 1000 + 3500 ))" # Guessing read speed
        sleep "$(echo "$NUM * $WORDS / 1" | bc)" # Simulating reading
    done
}

function main() {
    declare -a PIDS
    readonly URLS=( "https://github.com"
                    "https://en.wikipedia.org/wiki/Main_Page"
                    "https://stackexchange.com"
                    "https://edition.cnn.com"
                    "https://news.google.com/"
                    "https://www.nytimes.com"
                    "https://www.theguardian.com/international"
                    "https://gitlab.com/explore"
                    "https://techcrunch.com"
                    "https://www.wired.com"
                    "https://mashable.com/"
                    "https://www.theverge.com"
                    "https://www.digitaltrends.com"
                    "https://www.techradar.com"
                    "https://www.macrumors.com"
                    "https://www.cnet.com"
                  )
    readonly USERAGENT=( "Mozilla/6.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"
                         "Mozilla/5.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"
                         "Mozilla/5.0 (Windows NT 6.2; Win64; x64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"
                         "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:14.0) Gecko/20120405 Firefox/14.0a1"
                         "Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120405 Firefox/14.0a1"
                         "Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120405 Firefox/14.0a1"
                         "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1290.1 Safari/537.13"
                         "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1290.1 Safari/537.13"
                         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1290.1 Safari/537.13"
                         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1290.1 Safari/537.13"
                         "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3"
                         "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3"
                         "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3"
                       )
    for ((i=1; i<=7; i++)); do
        progress $i 7 "+ Starting #$1 instances of noisy.py "
        Engine "${URLS[$(( $RANDOM % ${#URLS[@]} ))]}" "${USERAGENT[$(( $RANDOM % ${#USERAGENT[@]} ))]}" &
        PIDS+=($!)
        sleep 0.2
    done
    cd ..

    echo
    echo "+ The party has Started!"

    local RESPONSE=""
    echo -ne "\n\n"
    echo "[ PRESS ANY KEY TO STOP ]"
    read RESPONSE

    echo -ne "\n"
    echo "+ Police breaking in ..."

    for PID in "${PIDS[@]}"; do
        echo -ne "\t* Terminating $PID ...\n"
        kill -9 "$PID"
        wait "$PID" 2>/dev/null
    done

    echo "+ Party Stopped!"
    #killall python
}

clear
logo

main
