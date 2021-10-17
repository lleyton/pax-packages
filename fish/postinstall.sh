#!/bin/sh

cat >> $(pwd)/../../etc/shells << "EOF"
/usr/local/bin/fish
EOF
