VER="5.1.0"
SRC="https://ftp.gnu.org/gnu/gawk/gawk-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv gawk-* src

mkdir -p pkg
(cd src                                                      &&
./configure --prefix=/usr   \
            --host="x86_64-pax-linux-gnu" \
            --build=$(./config.guess)                        &&
make                                                         &&
make DESTDIR=$(pwd)/../pkg install)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/gawk.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
