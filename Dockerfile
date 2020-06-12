FROM gentoo/stage3-amd64:latest as base

RUN emerge --sync --verbose --update
RUN emerge --verbose net-misc/ntp

WORKDIR /mnt/gentoo

RUN wget --debug --verbose -O stage3-amd64-hardened.tar.xz 'http://mirrors.evowise.com/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened/stage3-amd64-hardened-20200119T214502Z.tar.xz'

RUN tar xpvf stage3-amd64-hardened.tar.xz --xattrs-include='*.*' --numeric-owner

RUN ntpq -q -g
RUN mirrorselect --servers 5 --deep --debug 9 --country 'USA' --output >> 'mnt/gentoo/etc/portage/make.conf

RUN mkdir --parents /mnt/gentoo/etc/portage/repos.conf
RUN cp --verbose /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
RUN cp --verbose --dereference /etc/resolv.conf /mnt/gentoo/etc/resolv.conf

RUN mount --types proc /proc /mnt/gentoo/proc
RUN mount --rbind /sys /mnt/gentoo/sys
RUN mount --make-rslave /mnt/gentoo/sys
RUN mount --rbind /dev /mnt/gentoo/dev
RUN mount --make-rslave /mnt/gentoo/dev

