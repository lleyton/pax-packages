VER="1.2.11"
SRC="https://zlib.net/zlib-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv zlib-* src

mkdir -p pkg
(cd src &&
./configure --prefix=/usr                                    &&
make -j$(nproc)                                               &&
make DESTDIR=$(pwd)/../pkg install_root=$(pwd)/../pkg install &&
rm -fv $(pwd)/../pkg/usr/lib/libz.a)
cp package.toml pkg

( cd pkg && tar cJf ../../out/zlib.apkg * )

# Cleanup
rm -rf pkg src src.tar.xz
