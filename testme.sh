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

    # Empty String Test
    result="$(proxySetup '')"
    expected=""
    desc="Empty String Test"
    assertEquals "$desc" "$expected" "$result"

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
    assertEquals "$desc"  "$expected" "$result"

    # HTTP Test
    # With Flag
    result="$(proxySetup "http://1.1.1.1:53" "http")"
    expected=" --proxy http://1.1.1.1:53"
    desc="HTTP Proxy (with flag) Test"
    assertEquals "$desc"  "$expected" "$result"

    # HTTPS Test
    # With Malformed Flag
    result="$(proxySetup "https://1.1.1.1:53" "hxxps")"
    expected=""
    desc="HTTPS Proxy (with malformed flag) Test"
    assertEquals "$desc"  "$expected" "$result"
}

clear
logo

# TODO - ADD shUnit2 SETUP

. ./.shunit2/shunit2
