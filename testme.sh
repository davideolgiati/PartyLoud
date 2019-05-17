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

    # HTTPS Test
    # With Flag
    result="$(proxySetup "https://127.0.0.1:1234" "https")"
    expected=" --proxy-insecure --proxy https://127.0.0.1:1234"
    desc="HTTPS Proxy (with flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTP Test
    # With Flag
    result="$(proxySetup "http://127.0.0.1:1235" "http")"
    expected=" --proxy http://127.0.0.1:1235"
    desc="HTTP Proxy (with flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTPS Test
    # Missing Flag
    result="$(proxySetup "https://127.0.0.1:1234")"
    expected="3"
    desc="HTTPS Proxy (Missing flag) Test"
    assertEquals "$desc" "$expected" "$result"

    # HTTPS Test
    # With Missing Proto
    result="$(proxySetup "127.0.0.1:1234" "https")"
    expected="2"
    desc="HTTPS Proxy (with malformed flag) Test"
    assertEquals "$desc"  "$expected" "$result"

    # HTTPS Test
    # With fake Server
    result="$(proxySetup "https://127.0.0.1:1233" "https")"
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
    result="$(proxyResponseHandler " --proxy-insecure --proxy https://127.0.0.1:1234")"
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

source src/dns.sh

testRegexIP() {
    local result=""
    local expected=""
    local desc=""

    # CLASS A ADDRESSES
    # Boundary-driven testing
    # L-1 :  0.0.0.0
    # L   :  1.0.0.1
    # M   :  10.0.0.1
    # U   :  127.255.255.254
    # U+1 :  127.255.255.255

    # L-1
    result="$(IPCheck "0.0.0.0")"
    expected="1"
    desc="CLASS A IP Test -- L-1 : 0.0.0.0"
    assertEquals "$desc" "$expected" "$result"

    # L
    result="$(IPCheck "1.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- L : 1.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # M
    result="$(IPCheck "10.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- M : 10.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # U
    result="$(IPCheck "127.255.255.254")"
    expected="0"
    desc="CLASS A IP Test -- U : 127.255.255.254"
    assertEquals "$desc" "$expected" "$result"

    # L-1
    result="$(IPCheck "127.255.255.255")"
    expected="1"
    desc="CLASS A IP Test -- U+1 : 127.255.255.255"
    assertEquals "$desc" "$expected" "$result"

    # CLASS B ADDRESSES
    # Boundary-driven testing
    # L-1 :  128.0.0.0
    # L   :  128.0.0.1
    # M   :  130.0.0.1
    # U   :  191.255.255.254
    # U+1 :  191.255.255.255

    # L-1
    result="$(IPCheck "128.0.0.0")"
    expected="1"
    desc="CLASS A IP Test -- L-1 : 128.0.0.0"
    assertEquals "$desc" "$expected" "$result"

    # L
    result="$(IPCheck "128.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- L : 128.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # M
    result="$(IPCheck "10.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- M : 130.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # U
    result="$(IPCheck "191.255.255.254")"
    expected="0"
    desc="CLASS A IP Test -- U : 191.255.255.255"
    assertEquals "$desc" "$expected" "$result"

    # L-1
    result="$(IPCheck "191.255.255.255")"
    expected="1"
    desc="CLASS A IP Test -- U+1 : 191.255.255.255"
    assertEquals "$desc" "$expected" "$result"

    # CLASS C ADDRESSES
    # Boundary-driven testing
    # L-1 :  192.0.0.0
    # L   :  192.0.0.1
    # M   :  200.0.0.1
    # U   :  223.255.255.254
    # U+1 :  223.255.255.255

    # L-1
    result="$(IPCheck "192.0.0.0")"
    expected="1"
    desc="CLASS A IP Test -- L-1 : 192.0.0.0"
    assertEquals "$desc" "$expected" "$result"

    # L
    result="$(IPCheck "192.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- L : 192.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # M
    result="$(IPCheck "200.0.0.1")"
    expected="0"
    desc="CLASS A IP Test -- M : 200.0.0.1"
    assertEquals "$desc" "$expected" "$result"

    # U
    result="$(IPCheck "223.255.255.254")"
    expected="0"
    desc="CLASS A IP Test -- U : 223.255.255.254"
    assertEquals "$desc" "$expected" "$result"

    # L-1
    result="$(IPCheck "223.255.255.255")"
    expected="1"
    desc="CLASS A IP Test -- U+1 : 223.255.255.255"
    assertEquals "$desc" "$expected" "$result"
}

testDNSCheck() {
    local result=""
    local expected=""
    local desc=""

    # CheckDNS Base Test
    result="$(checkDNS "127.0.0.1")"
    expected="127.0.0.1"
    desc="checkDNS Base Test"
    assertEquals "$desc" "$expected" "$result"

    # CheckDNS NotAnIP Test
    result="$(checkDNS "NotAnIP")"
    expected=""
    desc="checkDNS NotAnIP Test"
    assertEquals "$desc" "$expected" "$result"

    # CheckDNS NotAnIP Test
    result="$(checkDNS "93.184.216.34")" # www.example.com
    expected=""
    desc="checkDNS NotAnIP Test"
    assertEquals "$desc" "$expected" "$result"

    # Basic Condition Coverage: 100%
}

testqueryDNS() {
    local result=""
    local expected=""
    local desc=""

    # CheckDNS Base Test
    result="$(queryDNS "www.example.com" "1.1.1.1")"
    expected="93.184.216.34"
    desc="queryDNS Base Test"
    assertEquals "$desc" "$expected" "$result"

    # Basic Condition Coverage: 100%
}

clear
logo

# TODO - ADD shUnit2 SETUP

(nc -l 1234 &>/dev/null) & # HTTPS Proxy
readonly PID1="$!"
(nc -l 1235 &>/dev/null) & # HTTP Proxy
readonly PID2="$!"
(nc -l 53 &>/dev/null) & # DNS
readonly PID3="$!"
. ./.shunit2/shunit2
kill -9 "${PID1}"
kill -9 "${PID2}"
kill -9 "${PID3}"
