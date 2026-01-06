# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more alias to avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# git
alias g="git"
alias gbr="git branch -a"
alias gst="git status"
alias gcp="git add . && git commit --amend --no-edit && git push -f"
alias grc="git rebase --continue"
alias grs="git rebase --skip"
alias grhh="git reset --hard HEAD"

# terraform
alias tri="terraform init"
alias trp="terraform plan"
alias trv="terraform validate"
alias tra="terraform apply --auto-approve"
alias trd="terraform apply -destroy --auto-approve"

# Kubernetes CLI
alias k="kubectl"
alias kgn="kubectl get node"
alias kgp="kubectl get pod"
alias kgpo="k get po -owide "
alias kgn="k get node "
alias kgs="k get svc "
alias kgd="k get deploy "
alias kn="kubectl config set-context --current --namespace "
alias kr="k run --dry-run=client -oyaml --image "
alias ka="k apply -f "
alias ke="k edit "
alias kd="k describe "
alias krep="k replace --force -f "
export do="--dry-run=client -oyaml "

# vim
alias vim="nvim"

# docker
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dcb="docker compose build"
alias dcr="docker compose down && docker compose up -d"

# Set a fancy prompt (non-color, overwrite the one in /etc/bash.bashrc)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Enable programmable completion features (you don't need to enable this,
# if it's already enabled in /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Initialize Homebrew environment
if [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/usr/local/Homebrew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
