checkDNS() {
    local -r IP="$1"
    if (timeout 0.3 echo >/dev/udp/"${IP}"/53 2>&1); then
        echo 1
    else
        echo 0
    fi
}

queryDNS(){
    local Uri="$1"
    local Dns=""
    local Entry=""
    local Out=""
    local Retry=0

    while [[ $(checkDNS "$Dns") -eq 0 ]] && [[ Retry < 5 ]]; do
        Entry="$(( RANDOM % DNSArraySize ))"
        Dns="$(sed "${Entry}q;d" "$DNSArray")"
        Out="$(timeout 0.5 host ${Uri} ${Dns})"
        Out="$(grep "has address" <<< ${Out} | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")"
        Retry="$(( Retry + 1 ))"
    done

    if [[ $Retry > 4 ]]; then
        Out=""
    fi

    echo "$Out"
}

generateDNSQuery() {
    if [[ "$DNSArray" == "" ]]; then
        echo ""
    else
        local Out="--resolve "
        local fsUri="$1"
        local Port=""

        if [[ "${Uri}" == http://* ]] ; then
            Port="80"
            Uri="${Uri:7}"
        elif [[ "${Uri}" == https://* ]] ; then
            Port="443"
            Uri="${Uri:8}"
        fi

        Uri="${Uri%%/*}"

        local Ip="$(queryDNS ${Uri})"

        if [[ "${Ip}" != "" ]] && [[ "${Port}" != "" ]]; then
            Out+="${Uri}:${Port}:${Ip}"
        else
            Out=""
        fi

        echo "$Out"
    fi

}
