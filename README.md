# Summary
I've met many people who struggle to set up a web security lab environment due to cost, time, or skills -- let's demolish those barriers! This project implements an **easy-to-use, free web security lab environment** for **students**, **developers** and **security professionals** to:
- Better understand web vulnerabilities by finding and exploiting them
- Practice web penetration testing safely and easily
- Create security trainings/workshops

This project automatically creates a Kali Linux lab VM containing 10+ intentionally vulnerable web applications/APIs. Vulnerable applications include [Juice Shop](https://owasp.org/www-project-juice-shop/), [WebGoat](https://github.com/WebGoat/WebGoat), and [NodeGoat](https://wiki.owasp.org/index.php/OWASP_Node_js_Goat_Project). For details about included vulnerable apps see [this Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps).

## ⚠️Security Warning⚠️
This VM contains lots of vulnerable software! You're responsible for your own security, don't get yourself or your organization pwned with this VM! This project takes the following security precautions:
- Avoids automatically starting intentionally vulnerable software
- Uses a private Virtualbox network without port forwarding
- Vulnerable applications listen on `127.0.0.1` rather than `0.0.0.0`

For another layer of protection, disconnect from your network after deploying the vulnerable applications, before running them.

# Usage
To get started [install Vagrant](https://developer.hashicorp.com/vagrant/docs/installation), [install Virtualbox](https://www.virtualbox.org/wiki/Downloads), and [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Then:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

You should run this on a computer with least 6GB of RAM (8GB+ is better). By default the VM uses 3GB of RAM. You can adjust this via the [`Vagrantfile`](Vagrantfile) `v.memory` variable.

### Plugin Installation: vagrant-reload
The first time you run `vagrant up` you may be prompted to install the `vagrant-reload` plugin. This is required for automated VM setup. You can accept the plugin installation, and then continue VM setup after installing:
```sh
vagrant up --provision
```

## Enabling Vulnerable Applications
**Vulnerable applications are NOT automatically launched** for security reasons. To launch a vulnerable application:
1. **Enable the application**: uncomment the relevant `use_app_name: true` line in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file. You can also change the port(s) it uses in this file by uncommenting and editing `appname_host_port*`.
2. **Deploy the application**: run `vagrant up --provision` to deploy the changes. This will create a directory for the application in the VM under `/home/vagrant/app-name`, and prepare the application to be launched.
3. **Launch the application**:
```sh
vagrant ssh
cd app-name
docker-compose up -d # runs the application in the background
```

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
- All the authors and contributors for these vulnerable applications! 
- The [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/)
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game by turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)