#!/bin/sh

VER="5.1.8"
SRC="https://ftp.gnu.org/gnu/bash/bash-$VER.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv bash-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=/usr                          \
                 --build=$(../src/support/config.guess) \
                 --host="$(uname -m)-pax-linux-gnu"     \
                 --with-installed-readline \
                 --without-bash-malloc &&
make -j$(nproc) &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install &&
rm -rf $(pwd)/../pkg/usr/share/info/dir)

cp postinstall.sh pkg
cp preremove.sh pkg
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/bash.apkg * )