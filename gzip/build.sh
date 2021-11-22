VER="1.10"
SRC="https://ftp.gnu.org/gnu/gzip/gzip-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv gzip-* src

mkdir -p pkg
(cd src                                                      &&
./configure --prefix=/usr   \
            --host="x86_64-pax-linux-gnu"                    &&
make                                                         &&
make DESTDIR=$(pwd)/../pkg install)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/gzip.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
