#!/bin/sh

VER="1.21.1"
SRC="https://ftp.gnu.org/gnu/wget/wget-$VER.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv wget-* src

mkdir -p pkg/usr pkg/etc build
(cd build &&
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make -j$(nproc) &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)

( cd pkg && tar --zstd -cf ../../out/wget.apkg * )