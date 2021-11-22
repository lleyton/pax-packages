VER="1.5.0"
SRC="https://github.com/facebook/zstd/releases/download/v$VER/zstd-$VER.tar.gz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv zstd-* src

mkdir -p pkg/usr
(cd src &&
make &&
make check &&
make prefix=$(pwd)/../pkg install &&
rm -v ../pkg/usr/lib/libzstd.a)
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/zstd.apkg * )

# Cleanup
rm -rf pkg src src.tar.xz
