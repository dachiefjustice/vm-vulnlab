# Web Vulnlab VM
This repo packages **10+ intentionally vulnerable web apps/APIs** with a [Kali Linux Vagrant VM](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/). It's an **easy-to-use, cross-platform, free and open-source web security training environment** to:
- Better understand web vulnerabilities by analyzing and exploiting them
- Practice web penetration testing safely and easily
- Create security trainings/workshops

The vulnerable applications cover a range of programming languages, vulnerability types ([OWASP top ten](https://owasp.org/Top10/) and more), and difficulty levels. Vulnerable applications include [Juice Shop](https://owasp.org/www-project-juice-shop/), [WebGoat](https://github.com/WebGoat/WebGoat), [NodeGoat](https://wiki.owasp.org/index.php/OWASP_Node_js_Goat_Project), and plenty more (see [this Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps) for details).

## 🛑⚠️Security Warning⚠️🛑
This VM contains lots of vulnerable software, don't get yourself or your organization pwned! You're responsible for your own security. If you're running this on a machine/network you don't control, get permission from your IT team!

This project takes the following security precautions:
- By default, vulnerable apps must be manually launched
- Uses a private Virtualbox network without port forwarding as a security layer
- Vulnerable applications (except CI/CD Goat) listen on `127.0.0.1` rather than `0.0.0.0`

For another layer of protection, disconnect from the network while running vulnerable apps (an internet connection is needed to set up them up initially).

## Requirements
### Software
You'll need these free tools that provide the cross-platform base for this repository:
- [Install Vagrant instructions](https://developer.hashicorp.com/vagrant/docs/installation)
- [Install Virtualbox instructions](https://www.virtualbox.org/wiki/Downloads)
- [Install Git instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 

### Hardware
Make sure you've got at least 6GB of RAM (8GB or more is better).

By default the VM uses 3GB of RAM. You can adjust this via the [`Vagrantfile`](Vagrantfile) `v.memory` variable, e.g. for 4GB of RAM:
```ruby
config.vm.provider "virtualbox" do |v|
    v.memory = 4096
```

# Usage
## VM Setup
On a machine meeting the prerequisites above:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

Automated VM setup uses the [`vagrant-reload` plugin](https://github.com/aidanns/vagrant-reload). This isn't bundled with Vagrant, so the first time you run `vagrant up` you may be prompted to install it; accept the installation prompt and then continue with:
```shell
vagrant up --provision
```

## Vulnerable Application Config
Each time you run `vagrant provision` or `vagrant up --provision` the VM will apply the settings from [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml).  Use this file to:
- Enable/disable each vulnerable application and view/change its ports
- Get links to each vulnerable application's documentation

## Using Vulnerable Applications
**Vulnerable applications are NOT automatically launched** for security reasons. To use a vulnerable application:
1. **Enable the application**: uncomment the relevant `use_app_name: true` line in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file. Make a note of its port(s), and open the application's docs to learn about using it. The ports listed here override the ports mentioned in the project's documentation.
2. **Deploy the application**: run `vagrant up --provision` to deploy the now-enabled application. This will create a directory for the application in the VM under `/home/vagrant/app-name` and prepare the application to be launched.
3. **Launch the application**:
```shell
vagrant ssh
cd app-name
docker-compose up -d # runs the application in the background
```
4. In the Kali VM, launch Firefox/Burp Suite/whatever tool and point it at `http://localhost:app_port` (using the port from step 2).

### Example: Use OWASP Juice Shop
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
```shell
vagrant ssh
cd juice-shop
docker-compose up -d # runs the application in the background
```
4. Launch Firefox or Burp Suite in the VM, point it towards http://localhost:3000, and start hacking!

# Lab Environment Details
## Ports
You can change the ports for each application by uncommenting and editing variables named like `appname_host_port*` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml).

Most vulnerable applications use a single port, some vulnerable applications use multiple ports/services.

The default ports are non-conflicting (except for the applications listed below, which use the ports defined in their repos/documentation):
- [crAPI](https://github.com/OWASP/crAPI)
- [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)

## Tech Stack
- Vagrant, Virtualbox, and Kali Linux ([`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling))
- Ansible (for automated provisioning)
- Docker and Docker Compose (for running the vulnerable applications)
- The programming languages, frameworks, and other components of the vulnerable applications

## Enabling Vulnerable Application Auto-Start
**🛑⚠️Warning: this is dangerous⚠️🛑** if you don't know what you're doing! Before proceeding make sure that you:
- **100% understand the security implications**
- **Have implemented adequate compensating controls** (see the Security Warning section)

With that warning out of the way, you can enable application auto-start by adding the following line to [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml):
```yaml
autostart_enabled_apps:     true
```

Then run a `vagrant up --provision`. Afterwards, the currently-enabled vulnerable apps (defined in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml)) will be automatically started each time you provision the VM.

# Credits & Inspiration
Special thanks to all the authors and contributors for these vulnerable applications, and to the authors of the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/).

Thanks also to:
- [Jeff Geerling](https://github.com/geerlingguy) for his [`geerlingguy.docker`](https://github.com/geerlingguy/ansible-role-docker) and [`geerlingguy.git`](https://github.com/geerlingguy/ansible-role-git) roles.
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game, turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)