#!/bin/bash

set -e

PASSPHRASE=bob
HOME_DEVICE=/dev/sda2
USER_ACCOUNT=alice

### Install pam_mount

if ! pacman -Qq | fgrep -qx pam_mount; then
    pacman --noconfirm -S pam_mount
fi

if ! fgrep -q pam_mount /etc/pam.d/system-auth; then
    patch /etc/pam.d/system-auth /vagrant/system-auth.patch
fi

### Create user account

if ! id $USER_ACCOUNT >/dev/null 2>&1; then
    useradd -M $USER_ACCOUNT
    echo -e "$PASSPHRASE\n$PASSPHRASE\n" | passwd $USER_ACCOUNT
fi

### Set up encrypted partition

if ! cryptsetup isLuks $HOME_DEVICE; then
    cryptsetup --key-file <(echo -n "$PASSPHRASE") luksFormat $HOME_DEVICE
    cryptsetup --key-file <(echo -n "$PASSPHRASE") luksOpen $HOME_DEVICE home
    mkfs.ext4 -q /dev/mapper/home
    mount /dev/mapper/home /mnt
    chown $USER_ACCOUNT.$USER_ACCOUNT /mnt
    chmod 700 /mnt
    umount /mnt
    cryptsetup luksClose home || true
fi

### Set up pam_mount

if [[ ! -d /home/$USER_ACCOUNT ]]; then
    mkdir /home/$USER_ACCOUNT
fi

if ! fgrep -q '<volume' /etc/security/pam_mount.conf.xml; then
    patch /etc/security/pam_mount.conf.xml /vagrant/pam_mount.conf.xml.patch
fi
