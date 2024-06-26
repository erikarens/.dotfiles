# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export PATH=/opt/homebrew/bin:$PATH
export ZSH="/Users/erikarens/.oh-my-zsh"
export DEFAULT_USER="erikarens"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#
# Currently used theme: https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#homebrew
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(

  zsh-autosuggestions
  )

source $ZSH/oh-my-zsh.sh

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
alias gl="git log --graph --color --all --decorate "
alias glo="git log --oneline --graph --color --all --decorate"
alias gundo="git reset --soft HEAD~"
alias gamend="git commit -av --amend --no-edit"
alias zshconfig="open ~/.zshrc"
alias install="brew install"
alias uninstall="brew uninstall"

# FUNCTIONS

function work() {
  cd ~/Development/Work
}

function private() {
  cd ~/Development/Private
}

function hl (){
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
  if [ -z $git_dir ]
  then
    cd ..
  else
    cd $git_dir
  fi
}

# Open JetBrains Rider with the solution file in the current directory.
# If the first argument is '.', it searches for and opens the .sln file in the current directory.
# If other arguments are provided, it passes them directly to the Rider CLI, allowing
# the function to be used for other Rider command-line functionalities.
function rider() {
    if [[ "$1" == "." ]]; then
        # Find the .sln file
	local solution_file=$(find . -maxdepth 1 -name "*.sln" | head -n 1)


        # Check if the solution file is found
        if [ -z "$solution_file" ]; then
            echo "No .sln file found in the current directory"
            return 1
        fi

        # Open the solution file with Rider
        open -na "Rider.app" --args "$solution_file"
    else
	# If any arguments other than '.' are given, pass them directly to the Rider CLI
        # This allows the function to support other Rider command-line functionalities
        ropen -na "Rider.app" --args "$@"
    fi
}

#Loads rbenv automatically - Ruby Version Manager
eval "$(rbenv init - zsh)"

# Loads NVM - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
source <(ng completion script)

# Android SDK Terminal Support
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

#Android Build Stuff
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Created by `pipx` on 2024-02-10 09:17:35
export PATH="$PATH:/Users/erikarens/.local/bin"

# Pipx autocompletion setup
autoload -U compinit
compinit
eval "$(register-python-argcomplete pipx)"

# JetBrains Rider
export PATH="$PATH:/Applications/Rider.app/Contents/MacOS"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
