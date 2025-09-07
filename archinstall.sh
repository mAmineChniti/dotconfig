#!/bin/bash
# Arch Linux one-click install script for dotconfig
set -e

# Helper: install yay if not present
if ! command -v yay &>/dev/null; then
    echo "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Main packages (official repos)
PKGS=(
    unzip
    zip
    tar
    curl
    wget
    zsh
    tmux
    fzf
    ripgrep
    xclip
    bat
    ruby
    python
    python-pip
    neovim
    go
    zoxide
    flatpak
    gnome-software
    xdg-desktop-portal-hyprland
)

sudo pacman -S --needed --noconfirm "${PKGS[@]}"
# Install atuin using official script
if ! command -v atuin &>/dev/null; then
    echo "Installing atuin via official script..."
    bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install colorls via gem
if ! gem list colorls -i &>/dev/null; then
    echo "Installing colorls via gem..."
    gem install colorls
    echo "Enabling colorls tab completion in .zshrc..."
    grep -q 'tab_complete.sh' "$HOME/.zshrc" || echo 'source $(dirname $(gem which colorls))/tab_complete.sh' >> "$HOME/.zshrc"
fi

# Nerd Font instructions
printf "\n[INFO] For best colorls experience, install a Nerd Font and set it in your terminal. See https://github.com/ryanoasis/nerd-fonts#install for instructions.\n"

# Zsh plugins
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] &&  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] &&  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Neovim personal config
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone -b personal-config https://github.com/mAmineChniti/nvim.git "$HOME/.config/nvim"
fi

# Install bun
# Install govm after go
if command -v go &>/dev/null; then
    echo "Installing govm..."
    go install github.com/melkeydev/govm@latest
fi

# Install nvm via official script
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm via official script..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Install bun
if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash
fi

# Install Homebrew (Linuxbrew) via official script
# Setup Flathub remote for Flatpak
if command -v flatpak &>/dev/null; then
    flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install gh and graphite via Homebrew
if command -v brew &>/dev/null; then
    brew install gh
    brew install withgraphite/tap/graphite
fi

# Install freedownloadmanager from AUR
if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm freedownloadmanager hakuneko-desktop-nightly
fi

# Install tmuxifier via git clone
if [ ! -d "$HOME/.tmuxifier" ]; then
    git clone https://github.com/jimeh/tmuxifier.git "$HOME/.tmuxifier"
fi

# TPM for tmux plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Symlink dotfiles
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.zsh_secret" "$HOME/.zsh_secret"

# Print success message
cat <<EOF

====================================
Dotconfig Arch install complete!
- All required packages and tools installed
- Dotfiles symlinked
- Neovim config set up
- Oh My Zsh and plugins ready
- Developer tools installed
- Tmux plugins ready
====================================

EOF
