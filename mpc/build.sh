#!/bin/sh

VER="1.2.1"
SRC="https://ftp.gnu.org/gnu/mpc/mpc-$VER.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xf src.tar.gz
mv mpc-* src

mkdir -p pkg
(cd src                                        &&
 ./configure --prefix=/usr                     \
             --disable-static                  \
             --docdir=/usr/share/doc/mpc-$VER  \
             --host="x86_64-pax-linux-gnu"     &&
make                                           &&
make html                                      &&
make check                                     &&
make DESTDIR=$(pwd)/../pkg install             &&
make DESTDIR=$(pwd)/../pkg install html)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/mpc.apkg * )

# Cleanup

rm -r pkg
rm -rf src
rm src.tar.gz
