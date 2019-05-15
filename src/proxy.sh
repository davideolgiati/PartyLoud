proxySetup() {
    local ret=""
    if [[ "${#}" == 2 ]]; then
        local Tmp=""
        local -r Input="${1}"; shift
        local -r Proto="${1}"; shift

        if [[ "${Input}" == "${Proto}"://* ]]; then
            if [[ "${Proto}" == "http" ]] ; then
                Tmp="${Input:7}"
            else
                Tmp="${Input:8}"
            fi

            local -r Ip="${Tmp%%:*}"
            local -r Port="${Tmp##*:}"
            local CurlOptions=""

            if (echo >/dev/tcp/"${Ip}"/"${Port}") &>/dev/null; then
                if [[ "${Proto}" == "https" ]]; then
                    CurlOptions=" --proxy-insecure"
                fi
                CurlOptions="${CurlOptions} --proxy ${Proto}://${Ip}:${Port}"
                ret="${CurlOptions}"
            else
                ret="1" # Can't reach the server
            fi
        else
            ret="2" # Flag Error
        fi
    else
        ret="3" # No Flag Provided
    fi
    echo "${ret}"
}

proxyResponseHandler() {
    local -r Input="${1}"; shift
    case "${Input}" in
        1)
            echo "[!] ProxySetup: can't reach the server"
            ;;
        2)
            echo "[!] ProxySetup: no match between flag and protocol"
            ;;
        3)
            echo "[!] ProxySetup: no flag/protocol provided"
            ;;
        *)
            echo "[+] ProxySetup Worked Fine"
            ;;
    esac
}
