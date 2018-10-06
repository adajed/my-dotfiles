#!/bin/bash

echo -e "Downloading zsh..."
sudo apt install zsh
echo -e "Downloading oh-my-zsh..."
sudo sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [ -f $HOME/.zshrc ]; then
    rm $HOME/.zshrc
fi
ln -s ${FOLDER}/zshrc.sh $HOME/.zshrc

echo -e "Downloading zsh-syntax-highlighting and zsh-autosuggestions..."
cd $HOME/.oh-my-zsh/custom/plugins
if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions
fi
cd ${FOLDER}

val=""
while [[ $val != "y"  &&  $val != "n" ]]; do
    echo -ne "Set zsh as default shell? [y/n] "
    read val
done

if [ $val = "y" ]; then
    chsh -s $(which zsh)
    echo -e "You have to logout and login again to finish zsh setup"
fi
