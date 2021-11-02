#!/bin/sh

VER="1.4.19"
SRC="https://ftp.gnu.org/gnu/m4/m4-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv m4-* src

mkdir -p pkg build
(cd build &&
../src/configure --prefix=/usr       &&
make -j$(nproc) tooldir=/usr         &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install &&
rm -rf $(pwd)/../pkg/usr/share/info/dir)

cp postinstall.sh pkg
cp preremove.sh pkg
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/m4.apkg * )

# Cleanup
rm -rf pkg build src src.tar.xz