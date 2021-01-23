FROM ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/London"

RUN apt-get update && apt-get -y upgrade

# Required Packages for the Host Development System
# http://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-host-development-system
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib g++-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     apt-utils tmux xz-utils debianutils iputils-ping libncurses5-dev

# Additional host packages required by poky/scripts/wic
RUN apt-get install -y curl dosfstools mtools parted syslinux tree zip

# Add "repo" tool (used by many Yocto-based projects)
RUN curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# Create user "jenkins"
RUN id jenkins 2>/dev/null || useradd --uid 1000 --create-home jenkins

# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 30000 --create-home build
RUN apt-get install -y sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

USER build
WORKDIR /home/build
CMD "/bin/bash"

FROM base as repo_prep

ENV SSTATE_DIR "~/sstate-cache"

RUN cd ~/ && export SSTATE_DIR="~/sstate-cache"
RUN git config --global user.email "you@example.com" && git config --global user.name "Your Name"
RUN git config --global color.ui false
RUN repo init -u https://github.com/matt2005/yocto_manifests.git -b main -m rpi4_x64.xml
RUN repo sync

FROM repo_prep AS RPI4_x64

RUN mkdir -p ~/rpi64/build/conf
RUN cp ~/rpi64/meta-rpi64/conf/local.conf.sample ~/rpi64/build/conf/local.conf
RUN cp ~/rpi64/meta-rpi64/conf/bblayers.conf.sample ~/rpi64/build/conf/bblayers.conf
RUN sed -i 's/IMAGE_FSTYPES = "tar.xz"/IMAGE_FSTYPES = "tar.xz rpi-sdimg"/g' ~/rpi64/build/conf/local.conf
RUN sed -i 's/MACHINE = "raspberrypi4-64"/#MACHINE = "raspberrypi4-64"/g' ~/rpi64/build/conf/local.conf
ENV MACHINE raspberrypi4-64
RUN source poky-dunfell/oe-init-build-env ~/rpi64/build
RUN bitbake qt5-image

FROM base as output
COPY --from=RPI4_x64 /home/build/rpi64/build/tmp/images/ /home/build/images/RPI4_x64/