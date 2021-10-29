SRC="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.53.tar.xz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv libcap-* src

mkdir -p pkg/usr build
(cd build &&
sed -i '/install -m.*STA/d' Makefile &&
make prefix=/usr lib=lib &&
make prefix=$(pwd)/../pkg/usr lib=lib install &&
chmod -v 755 ../pkg/usr/lib/lib{cap,psx}.so.2.53)

cp package.toml pkg

(cd pkg && tar cfJ ../../out/libcap.apkg *)
