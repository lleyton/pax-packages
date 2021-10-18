VER="4.4"
SRC="https://download.gnome.org/sources/gtk/$VER/gtk-$VER.0.tar.xz"

curl -L $SRC -o src.tar.xz
tar -xf src.tar.xz
mv gtk-* src

mkdir -p pkg build

(cd build &&
meson --prefix=$(pwd)/../pkg/usr --buildtype=release -Dbroadway-backend=true ../src &&
ninja -j4 &&
ninja install)

# Default GTK Configuration
mkdir -vp $(pwd)/pkg/etc/gtk-4.0/
cat > $(pwd)/pkg/etc/gtk-4.0/settings.ini << "EOF"
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
( cd pkg && tar cJf ../../out/gtk4.apkg * )

# Cleanup

rm -rf src
rm -rf build
rm -rf pkg
rm -rf src.tar.xz
