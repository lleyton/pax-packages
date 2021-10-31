SRC="https://github.com/Mic92/iana-etc/releases/download/20211004/iana-etc-20211004.tar.gz"

curl -L $SRC -o src.tar.gz
tar -xzf src.tar.gz
mv iana-etc-* src

mkdir -p pkg
cp src/protocols src/services pkg
cp package.toml pkg

( cd pkg && tar --zstd -cf ../../out/iana-etc.apkg * )