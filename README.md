# Web Vulnlab VM
This repo packages **10+ intentionally vulnerable web apps/APIs** with a [Kali Linux Vagrant VM](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/). It's an **easy-to-use, cross-platform, free and open-source web security training environment** to:
- Better understand web vulnerabilities by analyzing and exploiting them
- Practice web penetration testing safely and easily
- Create security trainings/workshops

## Vulnerable Apps & Guides
The vulnerable applications cover a range of programming languages, vulnerability types (including [OWASP top 10](https://owasp.org/Top10/)), and difficulty levels. **Massive thanks** to the authors and contributors of all these apps for their hard work! Click the links to learn more about each application.

| App + Docs                                                                  | Default Port(s)                                                            |
|-----------------------------------------------------------------------------|----------------------------------------------------------------------------|
| [Juice Shop](https://owasp.org/www-project-juice-shop/)                     | 3000 (web)                                                                 |
| [Yavuzlar Vulnlab](https://github.com/Yavuzlar/VulnLab)                     | 3001 (web)                                                                 |
| [RailsGoat](https://github.com/OWASP/railsgoat)                             | 3002 (web)                                                                 |
| [Damn Vulnerable Web App](https://github.com/digininja/DVWA)                | 3003 (web)                                                                 |
| [Damn Vulnerable GraphQL App](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application) | 3004                                                      |
| [NodeGoat](https://github.com/OWASP/NodeGoat)                               | 3005 (web)                                                                 |
| [SSRF Lab](https://github.com/incredibleindishell/SSRF_Vulnerable_Lab)      | 3006 (web)                                                                 |
| [WebGoat](https://github.com/WebGoat/WebGoat)                               | 4080 (WebGoat), 4090 (WebWolf)                                             |
| [Mutillidae](https://github.com/webpwnized/mutillidae)                      | 5080 (HTTP), 5443 (HTTPS), 5081 (DB Admin), 5389 (LDAP), 5082 (LDAP admin) |
| [VAmPI](https://github.com/erev0s/VAmPI)                                    | 6001 (secure), 6002 (vulnerable)                                           |
| [Damn Vulnerable Web Services](https://github.com/snoopysecurity/dvws-node) | 7080 (web), 7081 (GraphQL), 7090 (xmlrpc)                                  |
| [Security Shepherd](https://github.com/OWASP/SecurityShepherd/)             | 9080 (HTTP), 9443 (HTTPS), 9306 (main DB), 9017 (MongoDB)                  |
| [crAPI](https://github.com/OWASP/crAPI)                                     | See docs, run without other concurrent apps to avoid port conflicts        |
| [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)          | See docs, run without other concurrent apps to avoid port conflicts        | 

See [this Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps) for app deployment details.

## <a name="security-warning"></a> 🛑⚠️Security Warning⚠️🛑
This VM contains lots of vulnerable software, don't get yourself or your organization pwned! You're responsible for your own security. If you're running this on a machine/network you don't control, get permission from your IT team!

This project takes the following security precautions:
- By default, vulnerable apps must be manually launched
- Uses a private Virtualbox network without port forwarding as a security layer
- Vulnerable applications (except CI/CD Goat) listen on `127.0.0.1` rather than `0.0.0.0`

For another layer of protection, disconnect from the network while running vulnerable apps (an internet connection is needed for initial setup).

# Usage
## Summary
1. Clone/fork this repo
2. Enable the apps you want to use by uncommenting them in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml)
3. `vagrant plugin install vagrant-reload` (if you don't already have it)
4. `vagrant up && vagrant ssh`
5. `cd ~/app-name && docker-compose up -d`

More detailed instructions below.

## Requirements
### Software
You'll need these free tools that provide the cross-platform base for this repository:
- [Install Vagrant instructions](https://developer.hashicorp.com/vagrant/docs/installation)
- [Install Virtualbox instructions](https://www.virtualbox.org/wiki/Downloads)
- [Install Git instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 

### Hardware
Make sure you've got at least 6GB of RAM (8GB or more is better).

By default the VM uses 3GB of RAM. You can adjust this via the [`Vagrantfile`](Vagrantfile) `v.memory` variable (in MB). For example, to give the VM 4GB of RAM:
```ruby
config.vm.provider "virtualbox" do |v|
    v.memory = 4096
```

## VM Setup
On a machine meeting the prerequisites listed above:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

VM provisioning uses the [`vagrant-reload` plugin](https://github.com/aidanns/vagrant-reload). This isn't bundled with Vagrant, so the first time you run `vagrant up` you may be prompted to install it; accept the installation prompt and then continue with:
```shell
vagrant up --provision
```

## Vulnerable Application Config
Each time you run `vagrant provision` or `vagrant up --provision` the VM will apply the settings from [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml).  Use this file to enable vulnerable applications and view/change their ports.

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

## Enabling Vulnerable Application Auto-Start
**🛑⚠️Warning: this is dangerous⚠️🛑** if you don't know what you're doing! Before proceeding make sure that you:
- **100% understand the security implications**
- **Have implemented adequate compensating controls** (see the [Security Warning](#security-warning))

With that warning out of the way, you can enable vulnerable application auto-start by adding the following line to [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml):
```yaml
autostart_enabled_apps:     true
```

Then run a `vagrant up --provision`. Afterwards, the currently-enabled vulnerable apps (defined in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml)) will be automatically started.

# Lab Environment Details
## Ports
You can change the ports for each application by uncommenting and editing variables named like `appname_host_port*` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml). Most vulnerable applications use a single port, some vulnerable applications use multiple ports/services.

The default ports are non-conflicting (except for the applications listed below, which use the ports listed in their documentation):
- [crAPI](https://github.com/OWASP/crAPI)
- [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)

## Tech Stack
- Vagrant, Virtualbox, and Kali Linux ([`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling))
- Ansible (for automated provisioning)
- Docker and Docker Compose (for running the vulnerable applications)
- The programming languages, frameworks, and other components of the vulnerable applications

# Credits & Inspiration
Special thanks to all the authors and contributors for these vulnerable applications, and to the authors of the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/).

Thanks also to:
- [Jeff Geerling](https://github.com/geerlingguy) for his [`geerlingguy.docker`](https://github.com/geerlingguy/ansible-role-docker) and [`geerlingguy.git`](https://github.com/geerlingguy/ansible-role-git) roles.
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game, turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)