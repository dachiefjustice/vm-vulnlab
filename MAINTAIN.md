# Required Maintenance
- Whenever [upstream Ansible roles](roles/requirements.yml) are updated, pull the changes to this repository by running [scripts/refresh-roles.sh](scripts/refresh-roles.sh) and commit them.
- Whenever a new [`kalilinux/rolling`](https://app.vagrantup.com/kalilinux/boxes/rolling) box is available, recreate this VM:
```sh
cd this-repo
vagrant box update
vagrant destroy -f
vagrant up
```