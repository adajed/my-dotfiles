#!/bin/bash -x

echo -e "Downloading zsh..."
apt install zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "Downloading oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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

current_shell="$(cat /etc/passwd | grep $(whoami) | sed --expression='s/.*://g')"
zsh_shell="$(which zsh)"
if [ "${current_shell}" != "${zsh_shell}" ]; then
    echo -e "Your current shell is: ${current_shell}"
    val=""
    while [[ $val != "y"  &&  $val != "n" ]]; do
        echo -ne "Set zsh as default shell? [y/n] "
        read val
    done

    if [ $val = "y" ]; then
        echo -e "chsh -s ${zsh_shell}"
        chsh -s ${zsh_shell}
        echo -e "You have to logout and login again to finish zsh setup"
    fi
fi
