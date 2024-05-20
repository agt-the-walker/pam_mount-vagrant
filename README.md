# Purpose

This small project shows how to configure and use `pam_mount` on Arch Linux.
[Pam mount - ArchWiki](https://wiki.archlinux.org/index.php/pam_mount) says:

> To have an encrypted home partition (encrypted with, for example, LUKS or
> ecryptfs) mounted automatically when logging in, you can use pam\_mount. It
> will mount your /home (or whatever mount point you like) when you log in
> using your login manager or when logging in on console. The encrypted drive's
> passphrase should be the same as your linux user's password, so you do not
> have to type in two different passphrases to login. 

# Requirements

* [Git](https://git-scm.com/)
* [Packer](https://www.packer.io/)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

# Walkthrough

    $ cd ~/src/git  # or wherever you put your cloned github repos
      git clone https://github.com/agt-the-walker/packer-arch.git
      cd packer-arch/

    $ ./wrapacker
      vagrant box add arch output/packer_arch_virtualbox.box

    $ cd ~/src/git  # back to where we started
      git clone https://github.com/agt-the-walker/pam_mount-vagrant
      cd pam_mount-vagrant/

    $ vagrant up
      vagrant ssh

    vagrant@vagrant-arch$ df | grep ^/dev
    /dev/sda1       15349744   1288484  14044876   9% /

From the VirtualBox console, log in as `alice` (password `bob`). Let's check
that the crypted partition has been mounted:

    vagrant@vagrant-arch$ df | grep ^/dev
    /dev/sda1              15349744   1296680  14036680   9% /
    /dev/mapper/_dev_sda2   5026412     10232   4737808   1% /home/alice

From the VirtualBox console, log out. Let's check that the crypted partition
has been unmounted:

    vagrant@vagrant-arch$ df | grep ^/dev
    /dev/sda1              15349744   1296680  14036680   9% /

# Credits

* https://github.com/elasticdog/packer-arch: I forked this repository since
  I needed an extra partition for pam\_mount
* https://sourceforge.net/p/pam-mount/mailman/message/32345455/:
  `login.append` comes from this message.
