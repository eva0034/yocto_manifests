# yocto_testing

Testing of yocto for building rpi images

## 32 bit

- [ ] build raspberrypi zero image
- [ ] build raspberrypi 3 image
- [ ] build raspberrypi 4 image

## 64 bit
- [ ] build raspberrypi 3 image
- [ ] build raspberrypi 4 image


### wsl2

https://devblogs.microsoft.com/commandline/per-directory-case-sensitivity-and-wsl/

How to reproduce permissions error under WSL 2 running Ubuntu 18.04 on Windows 10 2004:
```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install build-essential git bison python3 flex diffstat gawk chrpath diffstat texinfo -y
```

Add qt5 and repeat above 

```bash
docker build -t matt2005/build-yocto:latest .
mkdir ~/yocto
docker run --mount type=bind,source=~/yocto,target=/home/build/yocto -ti matt2005/build-yocto:latest
```

## git setup

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

docker attach jovial_villani

## Raspberry Pi Zero

This took about 36 hours
```bash
cd ~/yocto
sudo chmod 777 ~/yocto
repo init -u https://github.com/matt2005/yocto_manifests.git -b main
repo sync
mkdir -p ~/yocto/rpi/build/conf
cp ~/yocto/rpi/meta-rpi/conf/local.conf.sample ~/yocto/rpi/build/conf/local.conf
cp ~/yocto/rpi/meta-rpi/conf/bblayers.conf.sample ~/yocto/rpi/build/conf/bblayers.conf
sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' ~/yocto/rpi/build/conf/local.conf
sed -i 's/MACHINE = "raspberrypi3"/#MACHINE = "raspberrypi3"/g' ~/yocto/rpi/build/conf/local.conf
sed -i 's/DISTRO_FEATURES = "ext2/DISTRO_FEATURES = "x11 ext2/g' ~/yocto/rpi/build/conf/local.conf
export MACHINE=raspberrypi0-wifi
source ~/yocto/poky-dunfell/oe-init-build-env ~/yocto/rpi/build
bitbake crankshaft-image
```

##Raspberry Pi 3
```bash
export MACHINE=raspberrypi3
source ~/poky-dunfell/oe-init-build-env ~/yocto/rpi/build
#bitbake core-image-base
#bitbake core-image-x11
bitbake core-image-sato-sdk
bitbake core-image-sato-sdk -c populate_sdk

```

## Raspberry Pi 4 x64

```bash
export MACHINE=raspberrypi4-64
source ~/yocto/poky-dunfell/oe-init-build-env ~/yocto/rpi/build
bitbake crankshaft-image
 scp tmp/log/cooker/raspberrypi4-64/202101*.log root@192.168.1.51:/root/logs


```