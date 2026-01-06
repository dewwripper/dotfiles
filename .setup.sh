#!/bin/bash

export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"

# Create symlinks for existing configurations
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
ln -sf "$PWD/.zshrc" "$HOME"/.zshrc
ln -sf "$PWD/.config/nvim" "$XDG_CONFIG_HOME"/nvim
ln -sf "$PWD/.config/fish" "$XDG_CONFIG_HOME"/fish
ln -sf "$PWD/.config/tmux" "$XDG_CONFIG_HOME"/tmux
ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
ln -sf "$PWD/.config/starship.toml" "$XDG_CONFIG_HOME"/starship.toml
ln -sf "$PWD/.config/btop.conf" "$XDG_CONFIG_HOME"/btop.conf

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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# Install zsh-nvm plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm" ]; then
  echo "Installing zsh-nvm..."
  git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm"
fi
