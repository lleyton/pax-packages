#!/bin/sh

VER="2.37"
SRC="https://ftp.gnu.org/gnu/binutils/binutils-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv binutils-* src

mkdir -p pkg build
(cd build &&
../src/configure --prefix=/usr       \
                 --enable-gold       \
                 --enable-ld=default \
                 --enable-plugins    \
                 --enable-shared     \
                 --disable-werror    \
                 --enable-64-bit-bfd &&
make -j$(nproc) tooldir=/usr         &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg tooldir=/usr install -j1 &&
rm -fv $(pwd)/../pkg/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a &&
rm -rf $(pwd)/../pkg/usr/share/info/dir)

cp postinstall.sh pkg
cp preremove.sh pkg
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/binutils.apkg * )

# Cleanup
rm -rf pkg build src src.tar.xz