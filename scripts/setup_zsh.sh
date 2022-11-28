#!/bin/bash -x

echo -e "Downloading zsh..."
apt install zsh -y
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "Downloading oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

if [ -f "$HOME/.zshrc" ]; then
    rm $HOME/.zshrc
fi
ln -s ${FOLDER}/zshrc.sh $HOME/.zshrc

echo -e "Downloading zsh-syntax-highlighting and zsh-autosuggestions..."
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${PLUGINS_DIR}/zsh-syntax-highlighting
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${PLUGINS_DIR}/zsh-autosuggestions
fi
