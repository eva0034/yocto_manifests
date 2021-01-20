```bash
mkdir -p /workdir
cd /workdir
repo init -u https://github.com/matt2005/yocto_manifests.git -b main
repo sync
mkdir -p /workdir/rpi/build/conf
cp /workdir/rpi/meta-rpi/conf/local.conf.sample /workdir/rpi/build/conf/local.conf
cp /workdir/rpi/meta-rpi/conf/bblayers.conf.sample /workdir/rpi/build/conf/bblayers.conf
sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' build/conf/local.conf
sed -i 's/MACHINE = "raspberrypi3"/#MACHINE = "raspberrypi3"/g' build/conf/local.conf
MACHINE=raspberrypi0-wifi
source poky-dunfell/oe-init-build-env /workdir/rpi/build
bitbake qt5-image
```
