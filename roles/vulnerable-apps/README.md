# Summary
This Ansible role automates setting up intentionally vulnerable web applications and APIs using Docker and Docker Compose on Kali Linux. This is useful for developers and security professionals to:
- Better understand web vulnerabilities by finding and exploiting them
- Practice penetration testing in a safe environment
- Create trainings/workshops

Check out [my VulnLab Kali Vagrant VM](https://gitlab.com/johnroberts/vm-vulnlab) for a fast, easy way to use this role.

## ⚠️Security Warning⚠️
This role sets up vulnerable applications! Don't get yourself or your organization pwned by exposing these services to a hostile network! You're responsible for your own security!

**Built-in Protections**
The role itself sets up most vulnerable applications to listen on `127.0.0.1` rather than `0.0.0.0`. Exceptions are applications that are using upstream Docker-Compose files, at the time of this writing:
- CI/CD Goat (which binds to all network interfaces in its Docker Compose file)
- crAPI (which binds to `127.0.0.1` in its Docker Compose file, but could change)

**Suggested Additional Protections**
- Use this with a private virtualized network for the Kali VM, and don't port-forward. This way everything is contained in the Kali VM.
- For more protection, disconnect from the network after setting up the vulnerable applications (an Internet connection is needed to provision the applications).

# Usage
Apply this role in an Ansible playbook to a Kali machine. Choose which apps to use (and their ports) by [overriding these variables](defaults/main.yml) from the playbook.

You can use [my VulnLab Kali Vagrant Virtualbox VM](https://gitlab.com/johnroberts/vm-vulnlab) to get going quickly, or [roll your own](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/):
```
Vagrant.configure("2") do |config|
  ##### BASE BOX #####
  config.vm.box = "kalilinux/rolling"

  ##### NETWORKING #####
  config.vm.network "private_network", type: "dhcp"

  ##### PROVISIONING VIA ANSIBLE ######
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook-using-this-role.yml"
  end
end
```

# Included Vulnerable Apps & APIs
Click through for information and instructions about each vulnerable application:
- [Juice Shop](https://owasp.org/www-project-juice-shop/)
- [NodeGoat](https://wiki.owasp.org/index.php/OWASP_Node_js_Goat_Project)
- [Mutillidae II](https://owasp.org/www-project-mutillidae-ii/)
- [RailsGoat](https://github.com/OWASP/railsgoat)
- [crAPI](https://github.com/OWASP/crAPI)
- [WebGoat](https://github.com/WebGoat/WebGoat)
- [VulnLab](https://github.com/Yavuzlar/VulnLab)
- [Damn Vulnerable Web Application (DVWA)](https://github.com/digininja/DVWA)
- [Damn Vulnerable GraphQL Application (DVGA)](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application)
- [SSRF Vulnerable Lab](https://github.com/incredibleindishell/SSRF_Vulnerable_Lab)
- [CI/CD Goat](https://github.com/cider-security-research/cicd-goat)
- [VAmPI](https://github.com/erev0s/VAmPI/tree/master)
- [DVWS-Node](https://github.com/snoopysecurity/dvws-node)

These apps were chosen based on GitHub stars, and ease of wrapping with `docker-compose`. 
Inspired by the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/) and my own experience.

# Supported Platforms
This role is built and tested to work with the [Vagrant box `kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling) (virtualbox provider).

# Credits
Thank you to the creators and contributers of all these vulnerable applications! I hope that me packaging these applications for practitioners to skill-up with is useful.