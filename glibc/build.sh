SRC="https://ftp.gnu.org/gnu/glibc/glibc-2.34.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv glibc-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
                 --disable-werror \
                 --enable-kernel=3.2 \
                 --enable-stack-protector=strong \
                 --with-headers=/usr/include \
                 --build=$(../src/scripts/config.guess) \
                 --host="x86_64-pax-linux-gnu"
                 libc_cv_slibdir=/usr/lib && 
make -j$(nproc) && 
make install)
cp package.toml pkg

(cd pkg && tar cfJ ../../out/glibc.apkg *)
