VER="5.10.73"
SRC="https://cdn.kernel.org/pub/linux/kernel/v${VER:0:1}.x/linux-$VER.tar.xz"


curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv linux-* src

(cd src && 
make defconfig && 
make -j$(nrpox))