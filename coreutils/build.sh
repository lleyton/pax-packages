VER="9.0"
SRC="https://ftp.gnu.org/gnu/coreutils/coreutils-9.0.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv coreutils-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
                 --host="x86_64-pax-linux-gnu" \
                 --build=$(../src/build-aux/config.guess) \
                 --enable-install-program=hostname \
                 --enable-no-install-program=kill,uptime &&
make -j$(nproc) &&
make install)
cp package.toml pkg

( cd pkg && tar cJf ../../out/coreutils.apkg * )