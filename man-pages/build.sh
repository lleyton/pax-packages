SRC="https://www.kernel.org/pub/linux/docs/man-pages/man-pages-5.13.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv man-pages-* src

mkdir -p pkg/usr
(cd src && make prefix=../pkg/usr install)
cp package.toml pkg

tar cfJ ../out/man-pages.apkg pkg/*