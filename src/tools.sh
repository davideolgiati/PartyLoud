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
		  "gawk"
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
    for COMMAND in "${SW[@]}"; do
	if [[ $TEST == true ]]; then
	    if [[ $(command -v "$COMMAND") ]]; then
		tput bold
		echo "[+] $COMMAND Found!"
		tput sgr0
	    else
		tput bold
		tput setaf 1
		echo "[!] $COMMAND not Found!!"
		tput sgr0
		TEST=false
	    fi
	fi
    done
}
