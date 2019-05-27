IPCheck() {
    local -r in="${1}"; shift

    if [[ "${in}" =~ ^(22[0-3]|2[0-1][0-9]|[01]?([0-9][0-9]|[1-9]))\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2}(25[0-4]|2[0-4][0-9]|[01]?([0-9][0-9]|[1-9]))$ ]]; then
        echo 0
    else
        echo 1
    fi
}

checkDNS() {
    local -r ip="${1}"; shift
    local out=""
    if [[ "$(IPCheck "${ip}")" -eq 0 ]] && (timeout 0.5 echo >/dev/tcp/"${ip}"/53) &>/dev/null; then
        out="${ip}"
    fi
    echo "${out}"
}

requestIP() {
    local -r url="${1}"; shift
    local -r dns="${1}"; shift

    timeout 0.5 host "${url}" "${dns}"
}

filterIP() {
    local -r in="${1}"; shift
    local -r dns="${1}"; shift

    grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" <<< "${in}" | # Taking only IP-like text
        grep -v "${dns}"                                     # Removing DNS IP
}

queryDNS() {
    local -r url="${1}"; shift
    local -r dns="${1}"; shift
    local out=""

    if isNotEmptyString "$(checkDNS "${dns}")"; then
        out="$(requestIP ${url} ${dns})"
        out="$(filterIP "${out}" "${dns}")"
    fi

    echo "${out}"
}

generateDNSQuery() {
    local uri="${1}"; shift
    local dns="${1}"; shift
    local out="--resolve "
    local port=""
    if isEmptyString "${dns}"; then
        echo ""
    else
        if isHttp "${uri}"; then
            port="80"
            uri="$(subStrFrom "${uri}" 7)"
        elif isHttps "${uri}"; then
            port="443"
            uri="$(subStrFrom "${uri}" 8)"
        fi

        uri="${uri%%/*}"

        local -r ip="$(queryDNS "${uri}" "${dns}")"

        if isNotEmptyString "${ip}" && isNotEmptyString "${port}"; then
            out+="${uri}:${port}:${ip}"
        else
            out=""
        fi

        echo "${out}"
    fi
}
