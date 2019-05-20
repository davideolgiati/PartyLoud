IPCheck() {
    if [[ "${1}" =~ ^(22[0-3]|2[0-1][0-9]|[01]?([0-9][0-9]|[1-9]))\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2}(25[0-4]|2[0-4][0-9]|[01]?([0-9][0-9]|[1-9]))$ ]]; then
        echo 0
    else
        echo 1
    fi
}

checkDNS() {
    local -r IP="${1}"; shift
    local out=""
    if [[ "$(IPCheck "${IP}")" -eq 0 ]] && (timeout 0.5 echo >/dev/tcp/"${IP}"/53) &>/dev/null; then
        out="${IP}"
    fi
    echo "${out}"
}

queryDNS() {
    local -r Uri="${1}"; shift
    local -r Dns="${1}"; shift
    local Out=""

    if [[ "$(checkDNS "$Dns")" != "" ]]; then
        Out="$(timeout 0.5 host ${Uri} ${Dns})"
        Out="$(grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" <<< ${Out} | grep -v "${Dns}")"
    fi

    echo "$Out"
}

generateDNSQuery() {
    local Uri="${1}"; shift
    local Dns="${1}"; shift
    local Out="--resolve "
    local Port=""
    if [[ "$Dns" == "" ]]; then
        echo ""
    else
        if [[ "${Uri}" == http://* ]]; then
            Port="80"
            Uri="${Uri:7}"
        elif [[ "${Uri}" == https://* ]]; then
            Port="443"
            Uri="${Uri:8}"
        fi

        Uri="${Uri%%/*}"

        local -r Ip="$(queryDNS "${Uri}" "${Dns}")"

        if [[ "${Ip}" != "" ]] && [[ "${Port}" != "" ]]; then
            Out+="${Uri}:${Port}:${Ip}"
        else
            Out=""
        fi

        echo "$Out"
    fi
}
