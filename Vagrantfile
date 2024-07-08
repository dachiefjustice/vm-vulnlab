Vagrant.configure("2") do |config|
  ##### PLUGINS #####
  # Prompts for first-time install
  config.vagrant.plugins = "vagrant-reload"

  ##### BASE BOX #####
  config.vm.box = "kalilinux/rolling"

  ##### NETWORKING #####
  config.vm.network "private_network", type: "dhcp"
  config.vm.hostname = "vm-vulnlab"

  ##### VIRTUALBOX CUSTOMIZATION ######
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 4096

    # Bidirectional clipboard
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end

  ##### PROVISIONING VIA ANSIBLE ######
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vulnlab-prereqs-playbook.yml"
  end

  # Reboot to add vagrant to docker group
  config.vm.provision :reload # this line can be commented-out after VM creation for faster deployments
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vulnlab-playbook.yml"
  end

  ##### FOLDER SHARING ######
  # Windows-host specific workaround for ansible_local provisioner to use the project's ansible.cfg
  config.vm.synced_folder ".", "/vagrant",  mount_options: ["dmode=775,fmode=755"]
end
