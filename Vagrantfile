Vagrant.configure("2") do |config|
  ##### BASE BOX #####
  config.vm.box = "kalilinux/rolling"

  ##### NETWORKING #####
  config.vm.network "private_network", type: "dhcp"
  config.vm.hostname = "vm-vulnlab"

  ##### VIRTUALBOX CUSTOMIZATION ######
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 3072

    # Bidirectional clipboard
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end

  ##### PROVISIONING VIA ANSIBLE ######
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vulnlab-prereqs-playbook.yml"
  end

  # Reboot to add vagrant to docker group
  config.vm.provision 'shell', reboot: true
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vulnlab-playbook.yml"
  end
end
