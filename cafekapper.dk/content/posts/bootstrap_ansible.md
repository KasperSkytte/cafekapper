---
title: "Bootstrap_ansible"
date: 2022-05-19T11:44:43Z
draft: true
ShowToc: false
TocOpen: false
---

## some title

```bash
#!/usr/bin/env bash
set -eu
ansible_venv=${ansible_venv:-"ansible-venv"}
playbook_file=${playbook_file:-"playbook.yml"}

message() {
    echo " *** $1..."
}

setup_ansible_venv() {
    message "Checking whether virtual environment already exists at ${ansible_venv}"
    if [ ! -s "${ansible_venv}/bin/activate" ]
    then
        message "Checking for required system packages"
        pkgs="software-properties-common python3-venv"
        if ! dpkg -s $pkgs >/dev/null 2>&1
        then
            message "One or more system packages are not installed, installing"
            sudo apt-get update -qqy
            sudo apt-get install -y $pkgs
        else
            message "All required system packages are already installed"
        fi
        message "Installing ansible into virtual environment: ${ansible_venv}"
        python3 -m venv "$ansible_venv"
        . "${ansible_venv}/bin/activate"
        python3 -m pip install ansible
        deactivate
    else
        message "Virtual environment already exists"
    fi
}

run_playbook() {
    #ansible-galaxy collection install community.general --roles roles
    ansible-galaxy install -r roles/requirements.yml --roles roles/ 2> /dev/null
    message "Running Ansible playbook \"${playbook_file}\" from virtual environment"
    . "${ansible_venv}/bin/activate"
    ansible-playbook "${playbook_file}" "$@"
    deactivate
}

setup_ansible_venv
run_playbook "$@"
```

Also available as a GitHub gist [here](https://gist.github.com/KasperSkytte/930f6763437dee91c36a3574f3677333)
