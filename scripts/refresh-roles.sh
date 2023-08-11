#!/bin/bash

# Run this from project root to refresh roles stored in external repos

# Remove roles installed from git repos
rm -rf roles/vulnerable-apps \
        roles/geerlingguy.docker \
        roles/geerlingguy.git

# Install project roles (refresh roles stored externally)
ansible-galaxy install -r roles/requirements.yml