#!/bin/sh

VER="5.40"
SRC="https://astron.com/pub/file/file-$VER.tar.gz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv file-* src

mkdir -p pkg build
(cd build &&
../src/configure --prefix=/usr       &&
make -j$(nproc) tooldir=/usr         &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)

cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/file.apkg * )

# Cleanup
rm -rf pkg build src src.tar.xz