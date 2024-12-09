#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


# https://github.com/blue-build/modules/blob/bc0cfd7381680dc8d4c60f551980c517abd7b71f/modules/rpm-ostree/rpm-ostree.sh#L16
echo "Creating symlinks to fix packages that install to /opt"
# Create symlink for /opt to /var/opt since it is not created in the image yet
mkdir -p "/var/opt"
ln -s "/var/opt"  "/opt"

dnf5 upgrade -y dnf5
# Install
dnf5 install -y 'dnf5-command(copr)' screen ntpd-rs sudo-rs vim htop wget

## Use ntpd-rs to replace chronyd
systemctl disable chronyd
systemctl enable ntpd-rs

# CachyOS
dnf5 copr enable -y bieszczaders/kernel-cachyos-addons
dnf5 -y install scx-scheds cachyos-settings uksmd
systemctl enable scx.service
systemctl enable uksmd.service