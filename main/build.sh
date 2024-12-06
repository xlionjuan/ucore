#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


# https://github.com/blue-build/modules/blob/bc0cfd7381680dc8d4c60f551980c517abd7b71f/modules/rpm-ostree/rpm-ostree.sh#L16
echo "Creating symlinks to fix packages that install to /opt"
# Create symlink for /opt to /var/opt since it is not created in the image yet
mkdir -p "/var/opt"
ln -s "/var/opt"  "/opt"


# Install
dnf5 install -y screen ntpd-rs sudo-rs vim htop wget

## Use ntpd-rs to replace chronyd
systemctl disable chronyd
systemctl enable ntpd-rs
