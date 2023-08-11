# Summary
I've seen many cases where people struggle to set up a vulnerable lab environment, due to cost or complexity. Those shouldn't be barriers to learning about security!

This project aims to overcome those barriers by implementing an easy-to-use, free lab environment for students, developers and security professionals. Use it to:
- Better understand web vulnerabilities by finding and exploiting them
- Safely practice penetration testing
- Create security trainings/workshops

The lab VM is built automatically from a `vagrant up` command, and contains 10+ intentionally vulnerable web applications/APIs (see [my vulnerable-apps Ansible role](https://gitlab.com/johnroberts/ansiblerole-vulnerable-apps) for more details about included vulnerable apps). Since it's based on Kali, a full security toolset is available out-of-the-box.

# Usage
**⚠️Important Warning⚠️**: this VM contains lots of vulnerable software! Don't get yourself or your organization pwned with it, you're responsible for your own security! This project takes the following precautions:
- The VM uses a private Virtualbox network without port forwarding
- Vulnerable applications listen on `127.0.0.1` rather than `0.0.0.0`

It's also recommended to disconnect from your network after deploying the vulnerable applications, before running them.

**⚙️Setup⚙️**
Install Vagrant and Virtualbox, then:
```sh
git clone https://gitlab.com/johnroberts/vm-vulnlab.git
cd vm-vulnlab
vagrant up
```

By default this will set up OWASP Juice Shop, Damn Vulnerable Web App, and Damn Vulnerable GraphQL Application.

## Choosing Vulnerable Applications
View/edit the variables named like `use_whatever_application` within [playbooks/vulnlab-playbook.yml](playbooks/vulnlab-playbook.yml).

## Vulnerable Application Ports
To learn which ports a given vulnerable application uses, check [roles/vulnerable-apps/defaults/main.yml](roles/vulnerable-apps/defaults/main.yml). Some applications have multiple services/ports.

These applications have non-editable ports, due to their complexity and/or issues when I tried changing their ports:
- [crAPI](https://github.com/OWASP/crAPI)
- [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)

# Tech Stack
- Vagrant, Virtualbox, and Kali Linux ([`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling))
- Ansible (for automated provisioning)
- Docker and Docker Compose (for running the vulnerable applications)

# Credits & Inspiration
- The [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/)
- All the authors and contributors for these vulnerable applications! 
- [Parsia](https://parsiya.net/about/) for inspiring me to up my automation game, by turning me onto [Manual Work is a Bug](https://queue.acm.org/detail.cfm?id=3197520&doi=10.1145%2F3194653.3197520)