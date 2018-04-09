#!/bin/bash

FOLDER=$(pwd)

USE_NVIM=0
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --nvim)
            USE_NVIM=1
            shift
        ;;
        *)
        echo "Unknown param $1"
        exit 1
        ;;
    esac
done

if [[ $USE_NVIM -eq 1 ]]; then
    if [ ! -d "$HOME/.config/nvim" ]; then
        mkdir $HOME/.config/nvim
    fi
fi

if [ -d "$FOLDER/.git" ]; then
    echo "Copying vimrc"
    rm $HOME/.vimrc
    ln -s ${FOLDER}/vimrc.vim $HOME/.vimrc
    if [[ $USE_NVIM -eq 1 ]]; then
        rm $HOME/.config/nvim/init.vim
        ln -s ${FOLDER}/vimrc.vim $HOME/.config/nvim/init.vim
    fi

    echo "Copying tmux.conf"
    rm $HOME/.tmux.conf
    ln -s ${FOLDER}/tmux.conf $HOME/.tmux.conf

    echo "Copying gitconfig"
    rm $HOME/.gitconfig
    ln -s ${FOLDER}/gitconfig $HOME/.gitconfig

    echo "Copying bash_aliases"
    rm $HOME/.bash_aliases
    ln -s ${FOLDER}/bash_aliases $HOME/.bash_aliases

    # create .vim dir if it doesn't exist
    if [ ! -d "$HOME/.vim" ]; then
        mkdir $HOME/.vim
    fi
    # create .vim/bundle if it doesn't exist
    if [ ! -d "$HOME/.vim/bundle" ]; then
        mkdir $HOME/.vim/bundle
    fi

    # download vundle if it doesn't exist
    vundle_dir="$HOME/.vim/bundle/Vundle.vim"
    if [ ! -d "${vundle_dir}" ]; then
        echo "Cloning Vundle..."
        git clone https://github.com/VundleVim/Vundle.vim.git ${vundle_dir}
    else
        echo "Vundle is already installed"
    fi

    # update and install all vim plugins
    echo "Installing vim plugins..."
    vim +PluginClean! +PluginUpdate +PluginInstall +qall
    python3 $HOME/.vim/bundle/youcompleteme/install.py --clang-completer
else
    echo "wrong directory :("
fi
