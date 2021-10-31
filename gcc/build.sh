#!/bin/sh

VER="11.2.0"
SRC="https://ftp.gnu.org/gnu/gcc/gcc-$VER/gcc-$VER.tar.xz"
ROOT=$(pwd)/pkg

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv gcc-* src

mkdir -p pkg build

(cd src &&
sed -e '/static.*SIGSTKSZ/d' \
    -e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
    -i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp &&
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac)

(cd build &&
../src/configure  --prefix=/usr                                       \
                  LD=ld                                               \
                  --enable-languages=c,c++                            \
                  --disable-multilib                                  \
                  --disable-bootstrap                                 \
                  --with-system-zlib                                  &&
                 # Like most programs, custom hosts are fucked
                 #--build=$(../src/config.guess)         \
                 #--host="x86_64-pax-linux-gnu"          && 
make -j$(nproc)                                                       &&
make DESTDIR=$ROOT install_root=$ROOT install                         &&
rm -rf $ROOT/usr/lib/gcc/$(gcc -dumpmachine)/$VER/include-fixed/bits/ &&
ln -svr $ROOT/usr/bin/cpp $ROOT/usr/lib                               &&
mkdir -pv $ROOT/usr/share/gdb/auto-load/usr/lib                       &&
mv -v $ROOT/usr/lib/*gdb.py $ROOT/usr/share/gdb/auto-load/usr/lib          )

rm pkg/usr/share/info/dir
cp package.toml pkg

(cd pkg && tar --zstd -cf ../../out/gcc.apkg *)
