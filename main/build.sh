#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


# https://github.com/blue-build/modules/blob/bc0cfd7381680dc8d4c60f551980c517abd7b71f/modules/rpm-ostree/rpm-ostree.sh#L16
echo "Creating symlinks to fix packages that install to /opt"
# Create symlink for /opt to /var/opt since it is not created in the image yet
mkdir -p "/var/opt"
ln -s "/var/opt"  "/opt"

# KVM PTP setup
echo "ptp_kvm" | tee /etc/modules-load.d/ptp_kvm.conf
echo 'OPTIONS="-s /dev/ptp0 -c CLOCK_REALTIME -O 0 -m"' | tee /etc/sysconfig/phc2sys

curl -fsSl https://xlionjuan.github.io/ntpd-rs-repos/rpm/xlion-ntpd-rs-repo.repo | tee /etc/yum.repos.d/xlion-ntpd-rs-repo.repo

dnf5 upgrade -y dnf5
# Install
dnf5 install -y 'dnf5-command(copr)' screen ntpd-rs sudo-rs vim htop wget linuxptp

## Use ntpd-rs to replace chronyd
systemctl disable chronyd
systemctl enable ntpd-rs

# KVM PTP setup
echo "ptp_kvm" | tee /etc/modules-load.d/ptp_kvm.conf
echo 'OPTIONS="-s /dev/ptp0 -c CLOCK_REALTIME -O 0 -m"' | tee /etc/sysconfig/phc2sys
systemctl enable phc2sys.service