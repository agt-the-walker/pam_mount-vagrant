# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "arch"  # https://github.com/agt-the-walker/packer-arch
  config.vm.provision 'shell', path: 'setup.sh'
  config.vm.provider 'virtualbox' do |v|
    v.gui = true
  end
end
