# Summary
I've met many people who lack the time or skillset to set up a lab environment to practice security, because of cost or complexity. These barriers shouldn't exist! This project aims to demolish those barriers by implementing an easy-to-use, free lab environment for students, developers and security professionals.

Use this project to:
- Better understand vulnerabilities by finding and exploiting them
- Practice penetration testing in a safe environment
- Create security trainings/workshops

This lab automatically creates a VM based on Kali Linux (so a full security toolset is available out-of-the-box). The lab VM builds automatically from a `vagrant up` command. It contains 10+ intentionally vulnerable applications/APIs. For details about included apps, see [my vulnerable-apps Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps).

# Usage
## ⚠️Important Warning⚠️
This VM contains lots of vulnerable software! Don't get yourself or your organization pwned with it, you're responsible for your own security! This project takes the following security precautions:
- Avoids automatically starting vulnerable software
- The VM uses a private Virtualbox network without port forwarding
- Vulnerable applications listen on `127.0.0.1` rather than `0.0.0.0`

It's also recommended to disconnect from your network after deploying the vulnerable applications, before running them.

## ⚙️Setup⚙️
To get started [install Vagrant](https://developer.hashicorp.com/vagrant/docs/installation), [install Virtualbox](https://www.virtualbox.org/wiki/Downloads), and [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Then:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

## Plugin installation: vagrant-reload
The first time you run `vagrant up`, you may be prompted to install the `vagrant-reload` plugin. This is required for automated VM setup. You can accept the plugin installation, and then continue VM setup after installing:
```sh
vagrant up --provision
```

## Choosing Vulnerable Applications and Ports
**Vulnerable applications are NOT automatically launched** for security reasons.

To start using a vulnerable application:
1. Uncomment its `use_app_name` line in [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) and save the file.
2. Run `vagrant up --provision` to apply the changes.

### Example: Enable OWASP Juice Shop
For example, to start using OWASP Juice Shop, edit [vars/vulnerable-app-config.yaml](vars/vulnerable-app-config.yaml) to look like:
```yaml
##### Juice Shop #####
# More info: https://owasp.org/www-project-juice-shop/
use_owasp_juiceshop:        true
# juiceshop_host_port:        '3000' 

# <other apps>
```

Then after editing, run `vagrant up --provision`.

Optionally, you can change the ports for each application. If you run multiple applications at once, make sure they don't use conflicting port numbers.

## Vulnerable Application Ports & Guides
To learn which ports a given vulnerable application uses and find guides/detailed information about them, check [roles/vulnerable-apps/defaults/main.yml](roles/vulnerable-apps/defaults/main.yml).

Some details:
- Most vulnerable applications use a single port
- Some vulnerable applications use multiple ports for different services
- Specific applications use non-editable ports, due to their complexity and/or facing issues when I tried changing their ports. For these applications, refer to their to their documentation to learn about their ports and usage:
    - [crAPI](https://github.com/OWASP/crAPI)
    - [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)

# Tech Stack
- Vagrant, Virtualbox, and Kali Linux ([`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling))
- Ansible (for automated provisioning)
- Docker and Docker Compose (for running the vulnerable applications)
- The programming languages, frameworks, and other components of the vulnerable applications

# Credits & Inspiration
- The [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/)
- All the authors and contributors for these vulnerable applications! 
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game by turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)