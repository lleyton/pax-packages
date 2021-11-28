#!/bin/bash

VER="3.10.0"
SRC="https://www.python.org/ftp/python/$VER/Python-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv Python-* src

mkdir -p pkg
(cd src                                     &&
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip &&
make -j$(nproc)                             && 
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)
cp package.toml pkg

(cd pkg && tar --zstd -cf ../../out/python3.apkg *)

# Cleanup
rm -rf pkg src src.tar.xz
