#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

remove_info() {
    # Update /usr/share/info/dir
    for i in $(pwd)/../../usr/share/info/$1.info*; do
        [ -f "$i" ] || break
        echo "${bold}Selecting previously unselected file $i${normal}"

        install-info --delete --info-dir="$(pwd)/../../usr/share/info" $i
    done
}

remove_info "gmp" 
