# Web Vulnlab VM
This repo provides a **free and open-source web-focused security training environment** for Linux, Windows, and MacOS. It packages **10+ intentionally vulnerable web apps** with a [Kali Linux Vagrant VM](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/). Use it to:
- Better understand vulnerabilities by analyzing and exploiting them
- Practice penetration testing safely and easily
- Create security trainings/workshops

**Massive thanks** to the authors and contributors of these vulnerable apps! This repo simply packages their work in a convenient way.

[**Watch this video**](https://github.com/dachiefjustice/vm-vulnlab/raw/main/docs/vm-vulnlab-demo-edited.mp4) to quickly understand how to use this repo.


## <a name="security-warning"></a> 🛑⚠️Security Warning⚠️🛑
This VM contains lots of vulnerable software! You're responsible for your own security, don't get yourself or your organization pwned! Get permission from your IT team if you're running this on a machine or network you don't control.

This project takes the following security precautions:
- Vulnerable apps must be manually launched
- Uses a private Virtualbox network without port forwarding
- Vulnerable applications listen on `127.0.0.1` rather than `0.0.0.0` (except CI/CD Goat due to Docker-in-Docker usage and inherent complexity)

For another layer of protection, disconnect from the network while running vulnerable apps (an internet connection is needed for initial setup).

# Usage
## Summary
1. Clone/fork this repo
2. `vagrant plugin install vagrant-reload` to enable automatic VM provisioning.
3. Edit [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) to enable individual vulnerable applications. Each time you run `vagrant up --provision` these settings are applied.
4. `cd vm-vulnlab && vagrant up`. Provisioning takes a few minutes depending on your internet speed and enabled apps. You'll be prompted to install the `vagrant-reload` plugin if you don't have it already.
5. Open the VM's Virtualbox window, log in with `vagrant/vagrant`, open a terminal and run `./start-app-name.sh`.
    - The per-app startup scripts print URLs for the running app and and its docs (control-click them to open).
6. When you're done using the app run `$HOME/stop-app-name.sh` from a shell in the VM. Changes to the app are saved (if the app supports it). Then run `vagrant halt` from a shell in the cloned repo to stop the VM.

More detailed instructions below.

## Requirements
### Software
You'll need these free tools:
- [Install Vagrant instructions](https://developer.hashicorp.com/vagrant/docs/installation)
- [Install Virtualbox instructions](https://www.virtualbox.org/wiki/Downloads)
- [Install Git instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 

### Hardware
You'll need at least 6GB of physical RAM (8GB+ is better).

By default the VM uses 3GB of RAM. You can adjust this via the [`Vagrantfile`](Vagrantfile) `v.memory` variable (in MB). For example:
```ruby
config.vm.provider "virtualbox" do |v|
    v.memory = 4096 # VM gets 4GB of RAM
```

## Initial VM Setup
On a machine meeting the prerequisites listed above:
```sh
git clone https://github.com/dachiefjustice/vm-vulnlab.git # or https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant plugin install vagrant-reload # for VM provisioning
vagrant up
```

VM provisioning uses the [`vagrant-reload` plugin](https://github.com/aidanns/vagrant-reload). You'll be prompted to install this plugin if you don't have it already. Accept the installation prompt, then continue VM provisioning: `vagrant up --provision`

## Using Vulnerable Applications (NodeGoat Example)
You can enable applications by editing [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and applying the changes with `vagrant up --provision`.

### Example: Enabling NodeGoat
1. **Enable NodeGoat**: set `use_app_name: true` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file.
```yaml
##### NodeGoat #####
use_owasp_nodegoat:     true # https://github.com/OWASP/NodeGoat
# nodegoat_host_port:     '3005'

# <other apps>
```
2. **Deploy NodeGoat**: run `vagrant up --provision`. This will:
    - Create the application's directory in the VM (`/home/vagrant/nodegoat` in this case)
    - Prepare the application to be launched.
    - Create start/stop scripts (`/home/vagrant/start-nodegoat.sh` and `/home/vagrant/stop-nodegoat.sh` in this case).
3. **Launch NodeGoat**: log into the VM's Virtualbox window (with `vagrant/vagrant` username/password), open a terminal and run `./start-nodegoat.sh`. This start script displays URLs to the running application and application's documentation, control-click to open them in the browser. Some applications might take a minute or two to finish setup the first time you launch them.
4. **Use NodeGoat**: in the Kali VM, launch Firefox/Burp Suite/whatever tool and point it at the running application.
5. **Stop NodeGoat**: when you're done using NodeGoat, open a terminal in the VM and run `$HOME/stop-nodegoat.sh`. Changes to the app are saved (if the app supports it). Then run `vagrant halt` from a shell in the cloned repo to stop the VM.

## Remove Vulnerable Applications
You can also disable applications to reclaim VM disk space. Note that this will destroy all changes to the application, such as progress you've made hacking the app so far!

### Example: Removing NodeGoat
1. **Disable the application**: set `use_app_name: false` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file.
```yaml
##### NodeGoat #####
use_owasp_nodegoat:     false # https://github.com/OWASP/NodeGoat
# nodegoat_host_port:     '3005'

# <other apps>
```
2. **Deploy the changes**: run `vagrant up --provision` to remove the now-disabled application from the VM. This will delete its containers, images, networks, volumes, directory, and start/stop scripts.

# Lab Environment Details
## Included Vulnerable Apps
The vulnerable applications cover a range of programming languages, vulnerability types (including [OWASP top 10](https://owasp.org/Top10/)), and difficulty levels. By default Juice Shop is deployed (but not automatically launched for security reasons).

| App Code + Docs                                                             | Default Port(s)                                                            |
|-----------------------------------------------------------------------------|----------------------------------------------------------------------------|
| [Juice Shop](https://owasp.org/www-project-juice-shop/)                     | 3000 (web)                                                                 |
| [Yavuzlar Vulnlab](https://github.com/Yavuzlar/VulnLab)                     | 3001 (web)                                                                 |
| [RailsGoat](https://github.com/OWASP/railsgoat)                             | 3002 (web)                                                                 |
| [Damn Vulnerable Web App (DVWA)](https://github.com/digininja/DVWA)         | 3003 (web)                                                                 |
| [Damn Vulnerable GraphQL App (DVGA)](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application) | 3004 (web)                                         |
| [NodeGoat](https://github.com/OWASP/NodeGoat)                               | 3005 (web)                                                                 |
| [SSRF Vulnerable Lab](https://github.com/incredibleindishell/SSRF_Vulnerable_Lab)  | 3006 (web)                                                          |
| [WebGoat](https://github.com/WebGoat/WebGoat)                               | 4080 (WebGoat), 4090 (WebWolf)                                             |
| [Mutillidae](https://github.com/webpwnized/mutillidae)                      | 5080 (HTTP), 5443 (HTTPS), 5081 (DB Admin), 5389 (LDAP), 5082 (LDAP admin) |
| [VAmPI](https://github.com/erev0s/VAmPI)                                    | 6001 (secure), 6002 (vulnerable)                                           |
| [Damn Vulnerable Web Services (DVWS)](https://github.com/snoopysecurity/dvws-node) | 7080 (web), 7081 (GraphQL), 7090 (XML-RPC)                          |
| [Security Shepherd](https://github.com/OWASP/SecurityShepherd/)             | 9080 (HTTP), 9443 (HTTPS)                                                  |
| [crAPI](https://github.com/OWASP/crAPI)                                     | See docs, run without other concurrent apps to avoid resource conflicts    |
| [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)          | See docs, run without other concurrent apps to avoid resource conflicts    |

## Tips
- VM default credentials: `vagrant/vagrant`
- VM provisioning is idempotent. Provision the VM anytime with `vagrant up --provision`. Or you can destroy and re-create the VM:
```shell
vagrant destroy -f
vagrant up
```
- After initial provisioning, you can disable the [`Vagrantfile`](Vagrantfile)'s first two provisioners for faster provisioning:
```ruby
  ##### PROVISIONING VIA ANSIBLE ######
  # config.vm.provision "ansible_local" do |ansible|
  #   ansible.playbook = "playbooks/vulnlab-prereqs-playbook.yml"
  # end

  # # Reboot to add vagrant to docker group
  # config.vm.provision :reload
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbooks/vulnlab-playbook.yml"
  end
```
- Run [crAPI](https://github.com/OWASP/crAPI) and [CI/CD Goat](https://github.com/cider-security-research/cicd-goat) without any other apps enabled to avoid port conflicts and running out of disk/RAM.

## Ports
You can change the ports for each application by uncommenting and editing variables named like `appname_host_port*` in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml). Most vulnerable applications use a single port, some use multiple ports/services.

The default ports are non-conflicting, except for [crAPI](https://github.com/OWASP/crAPI) and [CI/CD Goat](https://github.com/cider-security-research/cicd-goat) (which use the ports listed in their documentation).

## Tech Stack
- Vagrant, Virtualbox, and [`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling)
- Ansible for automated provisioning. Vulnerable application deployment logic is in [this Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps).
- Docker and Docker Compose for building/running the vulnerable applications
- The programming languages, frameworks, and other components of the vulnerable applications

# Credits & Inspiration
Special thanks to all the authors and contributors for these vulnerable applications, and to the authors of the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/).

Thanks also to:
- [Jeff Geerling](https://github.com/geerlingguy) for his [`geerlingguy.docker`](https://github.com/geerlingguy/ansible-role-docker) and [`geerlingguy.git`](https://github.com/geerlingguy/ansible-role-git) roles.
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game, turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)