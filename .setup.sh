#!/bin/bash

export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"

# Create symlinks for existing configurations
ln -sf "$PWD/.config/nvim" "$XDG_CONFIG_HOME"/nvim
ln -sf "$PWD/.config/fish" "$XDG_CONFIG_HOME"/fish
ln -sf "$PWD/.config/tmux" "$XDG_CONFIG_HOME"/tmux
ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
ln -sf "$PWD/.config/starship.toml" "$XDG_CONFIG_HOME"/starship.toml
ln -sf "$PWD/.config/btop.conf" "$XDG_CONFIG_HOME"/btop.conf


packages=(
  # starship
  # lazygit
  fzf
  fd
  ripgrep
  # make
  # cmake
  tmux
  btop
  eza
  neovim
  fish
  # gh

  # Kubernetes and Azure Tools
  # kubectl
  # helm
  # azure-cli
  # kubectx

)

# Iterate over the array and install each package
for package in "${packages[@]}"; do
  echo "Installing $package..."
  /home/linuxbrew/.linuxbrew/bin/brew install "$package"
done