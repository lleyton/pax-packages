#!/bin/sh

VER="4.8.0"
SRC="https://ftp.gnu.org/gnu/findutils/findutils-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv findutils-* src

mkdir -p pkg build
(cd build &&
../src/configure --prefix=/usr       \
                 --localstatedir=/var/lib/locate &&
make -j$(nproc) tooldir=/usr         &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install &&
rm -rf $(pwd)/../pkg/usr/share/info/dir)

cp postinstall.sh pkg
cp preremove.sh pkg
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/findutils.apkg * )

# Cleanup
rm -rf pkg build src src.tar.xz