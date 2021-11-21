SRC="https://ftp.gnu.org/gnu/glibc/glibc-2.34.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv glibc-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=/usr \
                 --disable-werror \
                 --enable-kernel=3.2 \
                 --enable-stack-protector=strong \
                 --disable-crypt \
                 --with-headers=/usr/include \
                 --build=$(../src/scripts/config.guess) \
                 --host="x86_64-pax-linux-gnu" \
                 libc_cv_slibdir=/usr/lib && 
make -j$(nproc) && 
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install)
cp package.toml pkg

(cd pkg && tar --zstd -cf ../../out/glibc.apkg *)
