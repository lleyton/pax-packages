VER="9.0"
SRC="https://ftp.gnu.org/gnu/coreutils/coreutils-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv coreutils-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
                 --host="x86_64-pax-linux-gnu" \
                 --build=$(../src/build-aux/config.guess) \
                 --enable-install-program=hostname \
                 --enable-no-install-program=kill,uptime &&
make -j$(nproc) &&
make install &&
mkdir -p $(pwd)/../pkg/usr/sbin &&
mv -v $(pwd)/../pkg/usr/bin/chroot              $(pwd)/../pkg/usr/sbin &&
mkdir -pv $(pwd)/../pkg/usr/share/man/man8 && 
mv -v $(pwd)/../pkg/usr/share/man/man1/chroot.1 $(pwd)/../pkg/usr/share/man/man8/chroot.8 &&
sed -i 's/"1"/"8"/'                    $(pwd)/../pkg/usr/share/man/man8/chroot.8)
rm pkg/usr/share/info/dir

cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/coreutils.apkg * )

# Cleanup

rm -rf pkg
rm -rf src
rm -rf build
rm -f src.tar.xz
