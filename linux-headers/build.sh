VER="5.10.73"
SRC="https://cdn.kernel.org/pub/linux/kernel/v${VER:0:1}.x/linux-$VER.tar.xz"


curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv linux-* src

mkdir -p pkg/usr
(cd src && 
make mrproper && 
make headers &&
find usr/include -name '.*' -delete &&
rm usr/include/Makefile &&
cp -rv usr/include $(pwd)/../pkg/usr)

cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/linux-headers.apkg * )