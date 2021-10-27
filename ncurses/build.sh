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
                 --enable-widec \
                 --with-termlib && 
make -j$(nproc) && 
make install)

(cd build &&
for lib in ncurses form panel menu tinfo ; do
    rm -vf                    $(pwd)/../pkg/usr/lib/lib${lib}.so
    ln $(pwd)/../pkg/usr/lib/lib${lib}w.so $(pwd)/../pkg/usr/lib/lib${lib}.so
    ln $(pwd)/../pkg/usr/lib/lib${lib}w.so $(pwd)/../pkg/usr/lib/lib${lib}.so.6
    ln $(pwd)/../pkg/usr/lib/lib${lib}w.so $(pwd)/../pkg/usr/lib/lib${lib}.so.6.3
done)

rm -fv $(pwd)/pkg/usr/lib/libncurses++w.a

cp package.toml pkg

(cd pkg && tar cfJ ../../out/ncurses.apkg *)
