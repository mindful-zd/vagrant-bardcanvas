Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 443, host: 8016
  config.vm.provision :shell, path: "provision.sh"
end
