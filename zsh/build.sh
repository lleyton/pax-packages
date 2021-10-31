VER="5.8"
SRC="https://www.zsh.org/pub/zsh-$VER.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv zsh-* src

mkdir -p pkg
(cd src &&
./configure --prefix=$(pwd)/../pkg/usr                                    \
            --sysconfdir=$(pwd)/../pkg/etc/zsh                            \
            --enable-etcdir=$(pwd)/../pkg/etc/zsh                         &&
make                                                                      &&
makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt                         &&
makeinfo  Doc/zsh.texi --html      -o Doc/html                            &&
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o Doc/zsh.html     &&
make install                                                              &&
make infodir=$(pwd)/../pkg/usr/share/info install.info                    &&
install -v -m755 -d                 $(pwd)/../pkg/usr/share/doc/zsh/html  &&
install -v -m644 Doc/html/*         $(pwd)/../pkg/usr/share/doc/zsh/html  &&
install -v -m644 Doc/zsh.{html,txt} $(pwd)/../pkg/usr/share/doc/zsh
)

cp postinstall.sh pkg
cp package.toml pkg
( cd pkg && tar --zstd cf ../../out/zsh.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
