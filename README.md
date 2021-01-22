# yocto_testing

Testing of yocto for building rpi images

## 32 bit

- [ ] build raspberrypi zero image
- [ ] build raspberrypi 3 image
- [ ] build raspberrypi 4 image

## 64 bit
- [ ] build raspberrypi 3 image
- [ ] build raspberrypi 4 image

Add qt5 and repeat above 

```bash
docker build -t gmacario/build-yocto:latest .
docker run -ti gmacario/build-yocto:latest
```

## git setup

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```


## Raspberry Pi Zero

This took about 36 hours
```bash
cd ~/
mkdir -p ~/sstate-cache
SSTATE_DIR="~/sstate-cache"
export SSTATE_DIR="~/sstate-cache"
repo init -u https://github.com/matt2005/yocto_manifests.git -b main
repo sync
mkdir -p ~/rpi/build/conf
cp ~/rpi/meta-rpi/conf/local.conf.sample ~/rpi/build/conf/local.conf
cp ~/rpi/meta-rpi/conf/bblayers.conf.sample ~/rpi/build/conf/bblayers.conf
sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' ~/rpi/build/conf/local.conf
sed -i 's/MACHINE = "raspberrypi3"/#MACHINE = "raspberrypi3"/g' ~/rpi/build/conf/local.conf
MACHINE=raspberrypi0-wifi
source poky-dunfell/oe-init-build-env ~/rpi/build
bitbake qt5-image
scp /home/build/raspwifi/qt5-image-raspberrypi0-wifi.rpi-sdimg root@192.168.1.51:/root/raspwifi/
```


## Raspberry Pi 4 x64

```bash
cd ~/
SSTATE_DIR="~/sstate-cache"
export SSTATE_DIR="~/sstate-cache"
repo init -u https://github.com/matt2005/yocto_manifests.git -b main -m rpi4_x64.xml
repo sync
mkdir -p ~/rpi64/build/conf
cp ~/rpi64/meta-rpi64/conf/local.conf.sample ~/rpi64/build/conf/local.conf
cp ~/rpi64/meta-rpi64/conf/bblayers.conf.sample ~/rpi64/build/conf/bblayers.conf
sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' ~/rpi64/build/conf/local.conf
sed -i 's/MACHINE = "raspberrypi4-64"/#MACHINE = "raspberrypi4-64"/g' ~/rpi64/build/conf/local.conf
MACHINE=raspberrypi4-64
source poky-dunfell/oe-init-build-env ~/rpi64/build
bitbake qt5-image

```