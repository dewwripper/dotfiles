# Dotfiles

Personal dotfiles for shell configuration and development tools.

## Features

- **Homebrew Installation**: Automatically installs Homebrew to the current user's environment
- **Shell Configurations**: Bash and Zsh configurations with aliases and customizations
- **Development Tools**: Includes popular CLI tools like nvim, tmux, fzf, ripgrep, etc.
- **Kubernetes Tools**: kubectl, helm, and Azure CLI support

## Quick Start

### Standard Setup

Run the setup script to install Homebrew (if not present) and all configured packages:

```bash
bash .setup.sh
```

This will:
1. Create symlinks for shell configurations
2. Install Homebrew to `$HOME/.linuxbrew` (on Linux) or standard locations (on macOS)
3. Install all configured packages via Homebrew

### Setup without Package Installation

To only create symlinks without installing packages:

```bash
bash .setup-no-install.sh
```

### Azure/Kubernetes Setup

For Azure and Kubernetes development with additional tools:

```bash
bash .setup-aks.sh
```

## Homebrew Installation

The dotfiles now support user-level Homebrew installation. The setup scripts will:

1. Check if Homebrew is already available
2. If not found, automatically install it to the current user's home directory
3. Configure the shell environment to use the user-installed Homebrew

### Manual Homebrew Installation

You can also install Homebrew manually:

```bash
bash .install-homebrew.sh
```

The installation script will:
- On **Linux**: Install to `$HOME/.linuxbrew` 
- On **macOS**: Install to `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)

The shell configurations (`.bashrc` and `.zshrc`) will automatically detect and initialize Homebrew from:
1. `$HOME/.linuxbrew` (user installation, highest priority)
2. `/home/linuxbrew/.linuxbrew` (system-wide Linux installation)
3. `/opt/homebrew` (macOS Apple Silicon)
4. `/usr/local` (macOS Intel)

## Included Tools

- **Shell**: fish, zsh configurations with Oh My Zsh (includes zsh-autosuggestions and zsh-nvm plugins)
- **Editor**: Neovim with custom configuration
- **Terminal Multiplexer**: tmux
- **CLI Tools**: starship (prompt), eza (ls replacement), fzf, fd, ripgrep
- **Git Tools**: lazygit, gh (GitHub CLI)
- **System Monitor**: btop
- **Kubernetes**: kubectl, helm, kubectx (AKS setup)
- **Azure**: azure-cli, kubelogin (AKS setup)

## Shell Aliases

See `.bashrc` and `.zshrc` for configured aliases including:
- Git shortcuts (`g`, `gst`, `gbr`, etc.)
- Kubernetes shortcuts (`k`, `kgp`, `kgs`, etc.)
- Docker Compose shortcuts (`dcd`, `dcu`, `dcr`)
- Terraform shortcuts (`tri`, `trp`, `tra`)

## License

Personal dotfiles - use at your own discretion.
