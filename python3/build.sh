#!/bin/bash

VER="3.10.0"
SRC="https://www.python.org/ftp/python/$VER/Python-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv Python-* src

mkdir -p pkg
(cd src                                     &&
 ./configure --prefix=/usr                  \
             --enable-shared                \
             --with-system-expat            \
             --with-system-ffi              \
             --with-ensurepip=yes           \
             --enable-optimizations         &&
             # Python requires readelf for the host
             #--build=$(../src/config.guess) \
             #--host="x86_64-pax-linux-gnu"  && 
make -j$(nproc)                             && 
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)
cp package.toml pkg

(cd pkg && tar cfJ ../../out/python3.apkg *)

# Cleanup
rm -rf pkg src src.tar.xz
