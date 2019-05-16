getLock() {
    while ! mkdir /tmp/partyloud.lock 2>/dev/null; do
        sleep 0.2
    done
}

freeLock() {
    rm -fr /tmp/partyloud.lock
}


SWCheck() {
    local -r SW=( "echo"
                  "curl"
                  "grep"
                  "sed"
                  "awk"
                  "wc"
                  "sort"
                  "uniq"
                  "kill"
                  "wait"
                  "rm"
                  "mkdir"
                  "printf"
                  "bc"
                )
    local Command=""
    local Offset=""
    for Command in "${SW[@]}"; do
        if [[ $TEST == true ]]; then
            if [[ $(command -v "$Command") ]]; then
                tput bold
                echo -ne "[+] $Command "
                Offset="$(( 10 - ${#Command} ))"
                tput cuf "$Offset"
                echo "Found!"
                tput sgr0
            else
                tput bold
                tput setaf 1
                echo -ne "[+] $Command "
                Offset="$(( 10 - ${#Command} ))"
                tput cuf "$Offset"
                echo "Found!"
                tput sgr0
                TEST=false
            fi
        fi
    done
}
