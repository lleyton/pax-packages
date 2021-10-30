SRC="https://www.openssl.org/source/openssl-1.1.1l.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv openssl-* src

mkdir -p pkg/usr
(cd src &&
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make -j$(nproc) && 
make DESTDIR=$(pwd)/../pkg install)

cp package.toml pkg

(cd pkg && tar cfJ ../../out/openssl.apkg *)
