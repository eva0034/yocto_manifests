## Building

I'm currently using an AWS EC2 instance (c5.xlarge) with Debian installed with a 200GB gp2 disk.

```bash 
mkdir -p ~/yocto
cd ~/yocto
sudo chmod 777 ~/yocto
repo init -u https://github.com/matt2005/yocto_manifests.git -b main -m opendash.xml
repo sync
mkdir -p ~/yocto/rpi/build/conf
cp ~/yocto/poky-hardknott/meta-opendash/conf/local.conf.sample ~/yocto/rpi/build/conf/local.conf
cp ~/yocto/poky-hardknott/meta-opendash/conf/bblayers.conf.sample ~/yocto/rpi/build/conf/bblayers.conf
export MACHINE=raspberrypi4-64
mkdir -p ~/yocto/sstate-cache
mkdir -p ~/yocto/download
export SSTATE_DIR="$(pwd)/sstate-cache"
export DL_DIR="$(pwd)/download"
source ~/yocto/poky-hardknott/oe-init-build-env ~/yocto/rpi/build
bitbake opendsh-image --runall=fetch
bitbake opendsh-image
```
