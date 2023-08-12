# Summary
This Ansible role automates deploying intentionally vulnerable web applications and APIs using Docker and Docker Compose on Kali Linux. This is useful for developers and security professionals to:
- Better understand web vulnerabilities by finding and exploiting them
- Practice penetration testing in a safe environment
- Create trainings/workshops

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

These apps were chosen based on GitHub stars, and ease of wrapping with `docker-compose`. 
Inspired by the [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/) and my own experience.

# Usage
Apply this role in a playbook to a [Vagrant-managed Kali VM](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/). Choose which apps and ports to use by overriding variables in [defaults/main.yml](defaults/main.yml) from the playbook.

**⚠️Important⚠️**: this sets up intentionally vulnerable applications! Don't get yourself or your organization popped! You're responsible for isolating these applications.

A handy way to do this: use a private Virtualbox network for the Kali VM, and don't port-forward. This way, everything is contained in the Kali VM. You can use [this example](https://gitlab.com/johnroberts/vm-vulnlab), or create your own based on this example:
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

Where possible, vulnerable applications have been configured to listen on `127.0.0.1` rather than `0.0.0.0` as added protection. As an added precaution, disconnect from the Internet after setting up the vulnerable applications (an Internet connection is needed to provision the applications).

# Supported Platforms
This role is built and tested to work with the [Vagrant box `kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling) (virtualbox provider).

# Credits
Thank you to the creators and contributers of all these vulnerable applications! I hope that me packaging these applications for practitioners to skill-up with is useful.