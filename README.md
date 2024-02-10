# .dotfile
The goal of this repo is to automate the setup of a new machine the way I want it and to securely store all the important settings and files I want to use on each machine.

# Install Ansible on the Maschine

To install`ansible` you should download `pipx` (https://github.com/pypa/pipx)
```bash
$ brew install pipx
$ pipx ensurepath
```

Then you can install `ansible`:
```bash
$ pipx install --include-deps ansible
```