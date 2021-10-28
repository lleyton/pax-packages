SRC="https://github.com/systemd/systemd/archive/refs/tags/v249.tar.gz"

curl -L $SRC -o systemd.tar.gz
tar -xzf systemd.tar.gz
mv systemd-* src

mkdir -p build pkg
(cd build &&
LANG=en_US.UTF-8                    \
meson --prefix=/usr    \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-249 \
      ../src &&
LANG=en_US.UTF-8 ninja &&
LANG=en_US.UTF-8 DESTDIR=$(pwd)/../pkg ninja install
)

cp package.toml pkg

( cd pkg && tar cJf ../../out/systemd.apkg * )
