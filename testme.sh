#!/bin/bash

logo(){
    cat <<'EOF'
                                                           /\
                                                          (  `.____[_]_________
                                                          |           __..--""
████████╗███████╗███████╗████████╗   ███╗   ███╗███████╗  (       _.-|
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝   ████╗ ████║██╔════╝   \    ,' | |
   ██║   █████╗  ███████╗   ██║█████╗██╔████╔██║█████╗      \  /   | |
   ██║   ██╔══╝  ╚════██║   ██║╚════╝██║╚██╔╝██║██╔══╝       \(    | |
   ██║   ███████╗███████║   ██║      ██║ ╚═╝ ██║███████╗      `    | |
   ╚═╝   ╚══════╝╚══════╝   ╚═╝      ╚═╝     ╚═╝╚══════╝           | |

 PartyLoud UnitTests
 written using
 shUnit2

EOF
}

# ProxyTests
source src/proxy.sh

testProxy() {
    local result=""
    local expected=""
    local desc=""

    # --- [ !!! ] ---
    # I know 1.1.1.1:53 is not a proxy but,
    # 1) it's always up
    # 2) proxySetup() do not check if there's a proxy running
    #    on the specified IP:Port
    # 3) any valid and active IP:Port conbination is fine
    # If you know a valid repalacement for 1.1.1.1:53,
    # please let me know on GitHub or Twitter
    # --- [ !!! ] ---

    # HTTPS Test
    # With Flag
    result="$(proxySetup "https://1.1.1.1:53" "https")"
    expected=" --proxy-insecure --proxy https://1.1.1.1:53"
    desc="HTTPS Proxy (with flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTP Test
    # With Flag
    result="$(proxySetup "http://1.1.1.1:53" "http")"
    expected=" --proxy http://1.1.1.1:53"
    desc="HTTP Proxy (with flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTPS Test
    # Missing Flag
    result="$(proxySetup "https://1.1.1.1:53")"
    expected="3"
    desc="HTTPS Proxy (Missing flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTPS Test
    # With Missing Proto
    result="$(proxySetup "1.1.1.1:53" "https")"
    expected="2"
    desc="HTTPS Proxy (with malformed flag) Test"
    assertEquals "$desc"  "$expected" "$result"

    # HTTPS Test
    # With fake Server
    result="$(proxySetup "https://1.1.1.1:65535" "https")"
    expected="1"
    desc="HTTPS Proxy (with malformed flag) Test"
    assertEquals "$desc"  "$expected" "$result"

    # Basic Condition Coverage: 100%
}

testProxyMessages() {
    local result=""
    local expected=""
    local desc=""

    # ProxySetup Test
    # OK
    result="$(proxyResponseHandler " --proxy-insecure --proxy https://1.1.1.1:53")"
    expected="[+] ProxySetup Worked Fine"
    desc="ProxySetup OK Test"
    assertEquals "$desc" "$expected" "$result"

    # ProxySetup Test
    # Server error
    result="$(proxyResponseHandler "1")"
    expected="[!] ProxySetup: can't reach the server"
    desc="ProxySetup Server Error Test"
    assertEquals "$desc" "$expected" "$result"

    # ProxySetup Test
    # Proto error
    result="$(proxyResponseHandler "2")"
    expected="[!] ProxySetup: no match between flag and protocol"
    desc="ProxySetup Proto Error Test"
    assertEquals "$desc" "$expected" "$result"

    # ProxySetup Test
    # OK
    result="$(proxyResponseHandler "3")"
    expected="[!] ProxySetup: no flag/protocol provided"
    desc="ProxySetup Flag Error Test"
    assertEquals "$desc" "$expected" "$result"


    # Basic Condition Coverage: 100%
}

#startServer() {
#    local -r Port="${1}"
#    nc -l "${Port}" &
#    echo "$!"
#}

clear
logo

# TODO - ADD shUnit2 SETUP

# readonly PID="$(startServer "1234")"
. ./.shunit2/shunit2
# kill -9 "${PID}"
