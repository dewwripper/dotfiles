#!/bin/bash

export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"

# Symlink $1 to $2, backing up an existing real file/dir instead of nesting the link inside it
link() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        mv "$2" "$2.bak.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sfn "$1" "$2"
}

# Create symlinks for existing configurations
link "$PWD/.bashrc" "$HOME"/.bashrc
link "$PWD/.zshrc" "$HOME"/.zshrc
link "$PWD/.config/nvim" "$XDG_CONFIG_HOME"/nvim
link "$PWD/.config/fish" "$XDG_CONFIG_HOME"/fish
link "$PWD/.config/tmux" "$XDG_CONFIG_HOME"/tmux
link "$PWD/.tmux.conf" "$HOME"/.tmux.conf
link "$PWD/.config/starship" "$XDG_CONFIG_HOME"/starship
link "$PWD/.config/starship/starship.toml" "$XDG_CONFIG_HOME"/starship.toml
link "$PWD/.config/fzf" "$XDG_CONFIG_HOME"/fzf
link "$PWD/.config/btop" "$XDG_CONFIG_HOME"/btop
link "$PWD/.config/btop/btop.conf" "$XDG_CONFIG_HOME"/btop.conf

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing..."
  bash "$PWD/.install-homebrew.sh"
  
  # Initialize Homebrew in current shell
  if [ -d "$HOME/.linuxbrew" ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d "/usr/local/Homebrew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

packages=(
  starship
  lazygit
  fzf
  zoxide
  direnv
  fd
  ripgrep
  tmux
  btop
  eza
  neovim
  zsh
  gh

  # Kubernetes and Azure Tools
  kubectl
  helm
)

# Iterate over the array and install each package
for package in "${packages[@]}"; do
  echo "Installing $package..."
  brew install "$package"
done

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
    echo "Warning: Oh My Zsh installation failed"
  }
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || {
    echo "Warning: zsh-autosuggestions installation failed"
  }
fi

# Install zsh-nvm plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm" ]; then
  echo "Installing zsh-nvm..."
  git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm" || {
    echo "Warning: zsh-nvm installation failed"
  }
fi
