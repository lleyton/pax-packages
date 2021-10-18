SRC="https://invisible-island.net/datafiles/release/ncurses.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv ncurses-* src

mkdir -p pkg/usr build
(cd build &&
../src/configure --prefix=$(pwd)/../pkg/usr \
                 --build=$(../src/config.guess) \
                 --mandir=$(pwd)/../pkg/usr/share/man \
                 --with-manpage-format=normal \
                 --with-shared \
                 --without-debug \
                 --without-ada \
                 --without-normal \
                 --with-termlib && 
make -j$(nproc) && 
make install)
cp package.toml pkg

(cd pkg && tar cfJ ../../out/ncurses.apkg *)