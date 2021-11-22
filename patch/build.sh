VER="2.7.6"
SRC="https://ftp.gnu.org/gnu/patch/patch-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv patch-* src

mkdir -p pkg
(cd src                                                      &&
./configure --prefix=/usr   \
            --host="x86_64-pax-linux-gnu" \
            --build=$(build-aux/config.guess)                &&
make                                                         &&
make DESTDIR=$(pwd)/../pkg install)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/patch.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
