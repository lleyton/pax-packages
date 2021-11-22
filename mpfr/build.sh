#!/bin/sh

VER="4.1.0"
SRC="https://www.mpfr.org/mpfr-$VER/mpfr-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv mpfr-* src

mkdir -p pkg
(cd src                                         &&
 ./configure --prefix=/usr                      \
             --enable-thread-safe               \
             --disable-static                   \
             --docdir=/usr/share/doc/mpfr-$VER  \
             --host="x86_64-pax-linux-gnu"      &&
make                                            &&
make html                                       &&
make check                                      &&
make DESTDIR=$(pwd)/../pkg install              &&
make DESTDIR=$(pwd)/../pkg install html)

rm -rf pkg/usr/share/info/dir
cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/mpfr.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
