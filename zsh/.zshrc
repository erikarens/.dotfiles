# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export PATH=/opt/homebrew/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export DEFAULT_USER="erikarens"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias o="open ."

alias ll="ls -la -G"
alias g="git"
alias gp="git pull"
alias gl="git log --graph --color --all --decorate"
alias glo="git log --oneline --graph --color --all --decorate"
alias gundo="git reset --soft HEAD~"
alias gamend="git commit -av --amend --no-edit"
alias zshconfig="open ~/.zshrc"
alias install="brew install"
alias uninstall="brew uninstall"

# Functions

function work() {
  cd ~/Development/Work
}

function private() {
  cd ~/Development/Private
}

function dotfiles() {
  cd ~/.dotfiles
}

function hl() {
  highlight -O rtf "$1" | pbcopy
  echo "code is copied to clipboard"
}

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Go to the root of the current git project, or just go one folder up
function up() {
  export git_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
  if [ -z $git_dir ]; then
    cd ..
  else
    cd $git_dir
  fi
}

# Open JetBrains Rider with the solution file in the current directory.
function rider() {
  if [[ "$1" == "." ]]; then
    local solution_file=$(find . -maxdepth 1 -name "*.sln" | head -n 1)
    if [ -z "$solution_file" ]; then
      echo "No .sln file found in the current directory"
      return 1
    fi
    open -na "Rider.app" --args "$solution_file"
  else
    open -na "Rider.app" --args "$@"
  fi
}

# Load rbenv automatically - Ruby Version Manager
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init - zsh)"
fi

# Load NVM - Node Version Manager
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
  source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Load Angular CLI autocompletion
if command -v ng &> /dev/null; then
  source <(ng completion script)
fi

# Android SDK Terminal Support and Build Stuff
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

# JetBrains Rider
export PATH="$PATH:/Applications/Rider.app/Contents/MacOS"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
