VER="4.3"
SRC="https://ftp.gnu.org/gnu/make/make-$VER.tar.gz"

curl -L $SRC -o src.tar.xz
tar -xzf src.tar.xz
mv make-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=/usr && 
make -j$(nproc) && 
make DESTDIR=$(pwd)/../pkg install)
rm pkg/usr/share/info/dir
cp package.toml pkg

(cd pkg && tar --zstd -cf ../../out/make.apkg *)
