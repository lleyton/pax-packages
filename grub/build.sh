VER="2.06"
SRC="https://ftp.gnu.org/gnu/grub/grub-$VER.tar.xz"

curl -L $SRC -o src.tar.gz
tar -xJf src.tar.gz
mv grub-* src

mkdir -p pkg/usr pkg/etc build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
            --sysconfdir=$(pwd)/../pkg/etc \
            --disable-efiemu \
            --disable-werror
make -j$(nproc) &&
make install)
cp package.toml pkg

( cd pkg && tar --zstd cf ../../out/grub.apkg * )