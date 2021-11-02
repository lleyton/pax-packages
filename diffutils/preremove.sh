#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)
pkg="diffutils"

# Update /usr/share/info/dir
for i in $(pwd)/../../usr/share/info/$pkg.info*; do
    [ -f "$i" ] || break
    echo "${bold}Selecting previously unselected file $i${normal}"

    install-info --delete --info-dir="$(pwd)/../../usr/share/info" $i
done