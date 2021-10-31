VER="3.24"
SRC="https://download.gnome.org/sources/gtk+/$VER/gtk+-$VER.30.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv gtk+-* src

mkdir -p pkg

(cd src &&
./configure --prefix=$(pwd)/../pkg/usr      \
            --sysconfdir=$(pwd)/../pkg/etc  \
            --enable-broadway-backend       \
            --enable-x11-backend            \
            --enable-wayland-backend        &&
make -j4                                    &&
make install)

# Default GTK Configuration
mkdir -vp $(pwd)/pkg/etc/gtk-3.0/
cat > $(pwd)/pkg/etc/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = Adwaita
gtk-font-name = DejaVu Sans 12
gtk-cursor-theme-size = 18
gtk-toolbar-style = GTK_TOOLBAR_BOTH_HORIZ
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-cursor-theme-name = Adwaita
EOF

cp package.toml pkg
( cd pkg && tar --zstd cf ../../out/gtk3+.apkg * )

# Cleanup

rm -r pkg
rm -r src
rm src.tar.xz
