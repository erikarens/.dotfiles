# .Dotfiles Repository

## Overview

This repo was created step by step over a long period of time and is tailored to my personal needs. The symlinking that is done makes it necessary to have a clone of this repo on the machine you want to configure.

This `.dotfiles` repository is a centralized collection of configuration files (dotfiles) and scripts for automating the setup of a development environment. It's designed to facilitate a quick and consistent configuration of tools like Zsh, Git, and Visual Studio Code across multiple machines.

All configuration files are added to the machine with symlinks so that every change you make is automatically recognized as a change in the repository and you can save it via push.

## Features

- Automated setup for essential tools like Git, Zsh, iTerm2, Autojump, NeoVim, Tmux and Visual Studio Code using Ansible.
- Secure management of SSH keys using Ansible Vault.
- Synchronization of configurations like `.zshrc` and `settings.json` for VSCode via symlinks.

## Prerequisites

Before using this repository, ensure the following tools are installed:

- **Git**: For cloning the repository.
- **Ansible**: For running the automation scripts.
- **GitHub Personal Access Token (PAT)**: Required for cloning the repository via HTTPS. Create a PAT with appropriate permissions on [GitHub](https://github.com/settings/tokens).

### Install Ansible

To install `ansible` we can use `pipx` to install `pipx` (https://github.com/pypa/pipx)

```bash
brew install pipx
pipx ensurepath
```

Then you can install `Ansible`:

```bash
pipx install --include-deps ansible
```

**I personally had some problems with `pipx` not finding the python interpreter, so I used pip to install `ansible`!**

## Setup Instructions

### 1. Clone the Repository

Use the following command to clone the repository. Replace `your_personal_access_token` with your GitHub PAT:

```bash
cd ~
git clone --recursive https://your_personal_access_token:x-oauth-basic@github.com/yourusername/.dotfiles.git
```

### 2. Run the Ansible Playbook

Navigate to the repository directory and execute the Ansible playbook:

```bash
cd ~
cd .dotfiles
cd ansible
export GITHUB_TOKEN=your_personal_access_token
ansible-playbook --ask-become-pass --ask-vault-pass setup.yml
```

This script automates the setup process, including the installation of necessary software and configuration of your development environment.

### 3. Post-Setup

After running the playbook, your environment will be set up with the configurations specified in the repository. This includes the setup of tools like Zsh and VSCode, along with the decryption and placement of SSH keys.

## Additional customizations after the setup

- Install and activate this powerline-patched nerd font and use it in iTerm2 [Source Code Pro for Powerline](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip)
- Install and configure Powerlevel10k as Zsh theme. [Installation guide here](https://github.com/romkatv/powerlevel10k#oh-my-zsh) and [setup video here](https://www.youtube.com/watch?v=CF1tMjvHDRA&ab_channel=JoseanMartinez)
- Activate the coolnight color preset you can find in `iterm2`
- Also configure macos like this [Macos Setup](./MACOS.md)

## Customization

- Customize configurations by modifying the files in the repository.
- Regularly commit and push changes to keep configurations synchronized across all machines.

## Security

- Keep your GitHub PAT and Ansible Vault password secure.
- Do not store unencrypted sensitive data in the repository.
- Keep encrypted data in a private submodule.

## Debugging

You can debug the ansible playbook with the `--check` flag

```bash
ansible-playbook --check --ask-become-pass --ask-vault-pass setup.yml -vvv
```

## Troubleshooting

- If you encounter issues, ensure your GitHub PAT is valid and has necessary permissions.
- Verify Ansible is correctly installed and configured on your machine.

## Future Updates

- [ ] Automate installation of gpg via Brew to sign git commits
- [ ] Automate installation of the .Net Runtime via Brew
