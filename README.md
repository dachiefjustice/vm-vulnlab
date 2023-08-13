# Summary
This project implements an **easy-to-use, cross-platform, free and open-source web security training environment** for **students**, **developers** and **security professionals** to:
- Better understand web vulnerabilities by finding and exploiting them
- Practice web penetration testing safely and easily
- Create security trainings/workshops

This repository sets you up with a fresh, customized [Kali Linux lab VM](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/) provisioned from infrastructure-as-code. The VM has everything you need to sharpen your web security skills:
- 10+ intentionally vulnerable web applications/APIs
- The tools to analyze and exploit them

The vulnerable applications cover a range of programming languages, vulnerability types ([OWASP top ten](https://owasp.org/Top10/) and more), and difficulty levels. Vulnerable applications include [Juice Shop](https://owasp.org/www-project-juice-shop/), [WebGoat](https://github.com/WebGoat/WebGoat), [NodeGoat](https://wiki.owasp.org/index.php/OWASP_Node_js_Goat_Project), and plenty more. For details about included vulnerable apps see [this Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps).

## Requirements
### Software
You'll need to:
- [ ] Install [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation)
- [ ] Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [ ] Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 

These tools provide the base for running the VM in a cross-platform way. They're free, and available for Linux/MacOS/Windows. The links above provide install instructions.

### RAM
You can run this VM on a Linux, Windows, or Mac machine with least 6GB of RAM. 8GB+ is better.

By default the VM uses 3GB of RAM. You can adjust this via the [`Vagrantfile`](Vagrantfile) `v.memory` variable, e.g. for 4GB of RAM:
```ruby
config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 4096
```

## ⚠️Security Warning⚠️
This VM contains lots of vulnerable software! You're responsible for your own security, don't get yourself or your organization pwned with this VM! This project takes the following security precautions:
- Avoids auto-starting intentionally vulnerable software
- Uses a private Virtualbox network without port forwarding (so the VM acts as a network security boundary)
- Vulnerable applications listen on `127.0.0.1` rather than `0.0.0.0`

For another layer of protection, disconnect from the network while running them (an internet connection is needed to set up the applications).

# Usage
Get a machine meeting the prerequisites above, then:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

### Plugin Installation: vagrant-reload
The first time you run `vagrant up` you may be prompted to install the [`vagrant-reload` plugin](https://github.com/aidanns/vagrant-reload). This is required for automated VM setup, so accept the plugin installation prompt and then continue afterwards:
```sh
vagrant up --provision
```

## Enabling Vulnerable Applications
**Vulnerable applications are NOT automatically launched** for security reasons. To launch a vulnerable application:
1. **Enable the application**: uncomment the relevant `use_app_name: true` line in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file. This file also tells you what ports the application uses, and links to the application's documentation. Open the application's docs, and make a note of the port it uses so you can use it once it's deployed. The ports listed here override the ports mentioned in the project's documentation.
2. **Deploy the application**: run `vagrant up --provision` to deploy the now-enabled application. This will create a directory for the application in the VM under `/home/vagrant/app-name` and prepare the application to be launched.
3. **Launch the application**:
```sh
vagrant ssh
cd app-name
docker-compose up -d # runs the application in the background
```
4. Launch Firefox/Burp Suite/whatever tool within the Kali VM and point it at `http://localhost:app_port` (using the port from step 2).

### Example: Launch OWASP Juice Shop
1. **Enable Juice Shop**: edit [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) to look like:
```yaml
##### Juice Shop #####
# More info: https://owasp.org/www-project-juice-shop/
use_owasp_juiceshop:        true
# juiceshop_host_port:        '3000' 

# <other apps>
```
2. **Deploy Juice Shop**: run `vagrant up --provision`
3. **Launch Juice Shop**: 
```sh
vagrant ssh
cd juice-shop
docker-compose up -d # runs the application in the background
```
4. Launch Firefox or Burp Suite in the VM, point it towards http://localhost:3000, and start hacking!

# Lab Environment Details
## Tech Stack
- Vagrant, Virtualbox, and Kali Linux ([`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling))
- Ansible (for automated provisioning)
- Docker and Docker Compose (for running the vulnerable applications)
- The programming languages, frameworks, and other components of the vulnerable applications

## Ports
You can change the ports for each application by uncommenting and editing variables named like `appname_host_port*` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml).

Most vulnerable applications use a single port, some vulnerable applications use multiple ports/services.

The default ports are non-conflicting (except for the applications listed below, which use the ports defined in their repos/documentation):
- [crAPI](https://github.com/OWASP/crAPI)
- [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)

# Credits & Inspiration
Special thanks to all the authors and contributors for these vulnerable applications, and to the authors of the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/).

Thanks also to:
- [Jeff Geerling](https://github.com/geerlingguy) for his [`geerlingguy.docker`](https://github.com/geerlingguy/ansible-role-docker) and [`geerlingguy.git`](https://github.com/geerlingguy/ansible-role-git) roles.
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game, turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)