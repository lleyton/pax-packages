VER="5.10.73"
SRC="https://cdn.kernel.org/pub/linux/kernel/v${VER:0:1}.x/linux-$VER.tar.xz"


curl -L $SRC -o src.tar.xz
tar -xJf src.tar.xz
mv linux-* src

mkdir -p pkg/boot pkg/lib/modules pkg/usr/share doc/linux-$VER
(cd src && 
make defconfig && 
make -j$(nrpox) &&
cp -iv arch/x86/boot/bzImage ../pkg/boot/vmlinuz-$VER-pax-11.0-systemd &&
cp -iv System.map /boot/System.map-$VER &&
cp -iv .config /boot/config-$VER &&
install -d ../pkg/usr/share/doc/linux-$VER &&
cp -r Documentation/* ../pkg/usr/share/doc/linux-$VER &&
install -v -m755 -d ../pkg/etc/modprobe.d &&
INSTALL_MOD_PATH=../pkg \
INSTALL_PATH=../pkg/boot \
make modules_install &&
cat > ../pkg/etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
)

cp package.toml pkg
tar cJf ../out/linux-$VER.apkg pkg/*