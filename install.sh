#!/bin/bash

FOLDER=$(pwd)

if [ -d "$FOLDER/.git" ]; then
    rm ~/.vimrc
    ln -s ${FOLDER}/vimrc.vim ~/.vimrc

    rm ~/.tmux.conf
    ln -s ${FOLDER}/tmux.conf ~/.tmux.conf

    rm ~/.gitconfig
    ln -s ${FOLDER}/gitconfig ~/.gitconfig

    rm ~/.bash_aliases
    ln -s ${FOLDER}/bash_aliases ~/.bash_aliases

    # create .vim dir if it doesn't exist
    if [ ! -d "~/.vim" ]; then
        mkdir ~/.vim
    fi
    # create .vim/bundle if it doesn't exist
    if [ ! -d "~/.vim/bundle" ]; then
        mkdir ~/.vim/bundle
    fi

    # download vundle if it doesn't exist
    vundle_dir="~/.vim/bundle/Vundle.vim"
    if [ ! -d "${vundle_dir}" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ${vundle_dir}
    else
        echo "vundle is already installed"
    fi

    # update and install all vim plugins
    vim +PluginClean! +PluginUpdate +PluginInstall +qall
    python3 ~/.vim/bundle/youcompleteme/install.py --clang-completer
else
    echo "wrong directory :("
fi
