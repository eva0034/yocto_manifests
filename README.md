```bash
docker build -t gmacario/build-yocto:latest .
docker run -ti gmacario/build-yocto:latest
```

```bash
sudo mkdir -p /workdir
sudo chown build.build /workdir
cd /workdir
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
repo init -u https://github.com/matt2005/yocto_manifests.git -b main
repo sync
mkdir -p /workdir/rpi/build/conf
cp /workdir/rpi/meta-rpi/conf/local.conf.sample /workdir/rpi/build/conf/local.conf
cp /workdir/rpi/meta-rpi/conf/bblayers.conf.sample /workdir/rpi/build/conf/bblayers.conf
sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' /workdir/rpi/build/conf/local.conf
sed -i 's/MACHINE = "raspberrypi3"/#MACHINE = "raspberrypi3"/g' /workdir/rpi/build/conf/local.conf
export MACHINE=raspberrypi0-wifi
source poky-dunfell/oe-init-build-env /workdir/rpi/build
HOME=/workdir
bitbake qt5-image
```
