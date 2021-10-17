VER="5.1.8"
SRC="https://ftp.gnu.org/gnu/bash/bash-$VER.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv bash-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
                 --build=$(../src/support/config.guess) \
                 --host="x86_64-pax-linux-gnu" \
                 --without-bash-malloc
make -j$(nproc) &&
make install)
cp package.toml pkg

( cd pkg && tar cJf ../../out/bash.apkg * )