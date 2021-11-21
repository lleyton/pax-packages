#!/bin/sh

VER="5.2.5"
SRC="https://tukaani.org/xz/xz-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv xz-* src

mkdir -p pkg/usr
(cd src &&
./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/xz-5.2.5 &&
make -j$(nproc) &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)

cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/xz.apkg * )