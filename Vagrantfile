
Vagrant.configure("2") do |config|
  config.vm.box = 'saucy'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-i386-vagrant-disk1.box'
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network "forwarded_port", guest: 8080, host: 8888
  config.vm.network "forwarded_port", guest: 3030, host: 3333
end
