#!/bin/sh

VER="6.2.1"
SRC="https://ftp.gnu.org/gnu/gmp/gmp-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv gmp-* src

mkdir -p pkg
(cd src                                                      &&
 ./configure --prefix=/usr                                   \
             --enable-cxx                                    \
             --disable-static                                \
             --docdir=/usr/share/doc/gmp-$VER                \
             --host="x86_64-pax-linux-gnu"                   &&
make                                                         &&
make html                                                    &&
make check 2>&1 | tee gmp-check-log                          &&
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log  &&
make DESTDIR=$(pwd)/../pkg install                           &&
make DESTDIR=$(pwd)/../pkg install html)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/gmp.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
