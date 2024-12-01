#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install ninja-build gettext cmake unzip curl build-essential wget2 wget curl zip unzip tar zsh tmux fzf ripgrep fd-find xclip bat perl ruby-full python3-full python-is-python3 clangd clang-format clang libclang-dev nala -y

read -p "git ssh set? (y/n) " git
if [ $git == "y" ]; then
    git clone git@github.com:neovim/neovim.git && cd neovim && sudo make CMAKE_BUILD_TYPE=Release && sudo make install && git clone -b personal-config https://github.com/mAmineChniti/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# wl-copy
sudo gem install colorls

read -p "Is this zsh? nvm, bun, rust, brew (y/n) " zsh
if [ $zsh == "y" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    curl -fsSL https://bun.sh/install | bash
    curl -fsSL https://deno.land/install.sh | sh

    read -p "Is go installed? (y/n) " go
    if [ $go == "y" ]; then
        echo "export PATH=$PATH:/usr/local/go/bin" >>~/.zshrc
        echo "export PATH=$PATH:$(go env GOPATH)/bin" >>~/.zshrc
        echo "export GOBIN=$HOME/go/bin" >>~/.zshrc
        echo "export PATH=$PATH:$GOBIN" >>~/.zshrc
    fi
fi

read -p "Is nvim, nvm, pip, cargo, perl installed? (y/n) " nvim
if [ $nvim == "y" ]; then
    sudo apt install lua5.3 liblua5.3-dev lua5.1 liblua5.1-dev luajit libluajit-5.1-dev libluajit-5.3-dev -y
    npm i -g neovim@latest
    pip install neovim
    cargo install neovim
    sudo cpan install Neovim::Ext
fi
