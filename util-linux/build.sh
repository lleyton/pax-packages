#!/bin/bash

set -e

SRC="https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.2.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv util-linux-* src

mkdir -p pkg
(cd src                                                &&
 ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime     \
             --libdir=/usr/lib                         \
             --docdir=/usr/share/doc/util-linux-2.37.2 \
             --disable-chfn-chsh                       \
             --disable-login                           \
             --disable-nologin                         \
             --disable-su                              \
             --disable-setpriv                         \
             --disable-runuser                         \
             --disable-pylibmount                      \
             --disable-static                          \
             --without-python                          \
             --host="x86_64-pax-linux-gnu"             \
             runstatedir=/run                          &&
 make -j$(nproc)                                       &&
 sudo make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)


cp package.toml pkg

(cd pkg && tar cfJ ../../out/util-linux.apkg *)

# Cleanup
sudo rm -r pkg
rm -rf src src.tar.xz
