SRC="https://ftp.gnu.org/gnu/readline/readline-8.1.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xf src.tar.gz
mv readline-* src

mkdir -p pkg/usr
( cd src &&
./configure --prefix=$(pwd)/../pkg/usr    \
            --disable-static \
            --with-curses &&
make SHLIB_LIBS="-lncursesw" -j$(nproc) && 
make SHLIB_LIBS="-lncursesw" install)
rm pkg/usr/share/info/dir

cp package.toml pkg

(cd pkg && tar cfJ ../../out/readline.apkg *)