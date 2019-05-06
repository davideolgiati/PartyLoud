proxySetup() {
    local -r Input="${1}"
    local Tmp=""
    local Proto="$2"

    if [[ "${Input}" == http://* ]] ; then
        Proto="http"
        Tmp="${Input:7}"
    elif [[ "${Input}" == https://* ]] ; then
        Proto="https"
        Tmp="${Input:8}"
    else
        Tmp="${input}"
    fi

    local -r Ip="${Tmp%%:*}"
    local -r Port="${Tmp##*:}"
    local CurlOptions=""

    if (echo >/dev/tcp/"${Ip}"/"${Port}") &>/dev/null; then

        if [[ "${Proto}" == "https" ]]; then
            CurlOptions=" --proxy-insecure"
        fi

        CurlOptions="${CurlOptions} --proxy ${Proto}://${Ip}:${Port}"
    fi

    echo "${CurlOptions}"
}
