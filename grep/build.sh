VER="3.7"
SRC="https://ftp.gnu.org/gnu/grep/grep-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv grep-* src

mkdir -p pkg
(cd src                                                      &&
./configure --prefix=/usr   \
            --host="x86_64-pax-linux-gnu"                    &&
make                                                         &&
make DESTDIR=$(pwd)/../pkg install)

cp preremove.sh pkg
cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd -cf ../../out/grep.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
