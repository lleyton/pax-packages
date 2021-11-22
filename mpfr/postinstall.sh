#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

# Update /usr/share/info/dir
for i in ./usr/share/info/*.info*; do
    [ -f "$i" ] || break
    echo "${bold}Selecting previously unselected file $i${normal}"

    install-info --info-dir="$(pwd)/../../usr/share/info" $i
done 
