#!/bin/sh

VER="1.34"
SRC="https://ftp.gnu.org/gnu/tar/tar-$VER.tar.xz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv tar-* src

mkdir -p pkg/usr
(cd src &&
./configure --prefix=/usr                     \
            --host="x86_64-pax-linux-gnu"                   \
            --build=$(build-aux/config.guess) &&
make -j$(nproc) &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)

( cd pkg && tar --zstd -cf ../../out/tar.apkg * )