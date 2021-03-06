#!/bin/sh

VER="1.21.1"
SRC="https://ftp.gnu.org/gnu/wget/wget-$VER.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv wget-* src

mkdir -p pkg/usr pkg/etc build
(cd build &&
../src/configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make -j$(nproc) &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)
rm pkg/usr/share/info/dir

cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/wget.apkg * )