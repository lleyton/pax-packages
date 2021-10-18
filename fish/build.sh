VER="3.3.1"
SRC="https://github.com/fish-shell/fish-shell/releases/download/$VER/fish-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv fish-* src

mkdir -p pkg build
(cd build                                                    &&
cmake -DCMAKE_INSTALL_PREFIX=$(pwd)/../pkg/usr/local ../src  &&
make                                                         &&
make install)

cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar cJf ../../out/fish.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm -r build
rm src.tar.xz
