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
ln -sf "$PWD/.config/starship" "$XDG_CONFIG_HOME"/starship
ln -sf "$PWD/.config/starship/starship.toml" "$XDG_CONFIG_HOME"/starship.toml
ln -sf "$PWD/.config/btop" "$XDG_CONFIG_HOME"/btop
ln -sf "$PWD/.config/btop/btop.conf" "$XDG_CONFIG_HOME"/btop.conf
