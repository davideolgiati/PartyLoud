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

-d --dns <file>                    DNS Servers are sourced from specified FILE,
                                   each request will use a different DNS Server
                                   in the list
                                   !!WARNING THIS FEATURE IS EXPERIMENTAL!!
                                   !!PLEASE LET ME KNOW ISSUES ON GITHUB !!
-l --url-list <file>               read URL list from specified FILE
-b --blocklist <file>              read blocklist from specified FILE
-p --http-proxy <http://ip:port>   set a HTTP proxy
-s --https-proxy <https://ip:port> set a HTTPS proxy
-n --no-wait                       disable wait between one request and an other
-h --help                          dispaly this help

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
