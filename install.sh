#!/bin/bash

FOLDER=$(pwd)

# check if file exists before removing it
safe_rm() {
    _path=$1
    if [ -f "$_path" ]; then
        rm "$_path"
    fi
}

create_dir() {
    _path=$1
    if [ ! -d "${_path}" ]; then
        mkdir ${_path}
    fi
}

USE_NVIM=0
UPDATE_PLUGINS=1
VIM="vim"
VIM_COMMANDS="+PluginClean! +PluginUpdate +PluginInstall"

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h)
            echo "Usage: $0 [--nvim] [--noupdate]"
            exit 0
        ;;
        --nvim)
            USE_NVIM=1
            shift
        ;;
        --noupdate)
            UPDATE_PLUGINS=0
            shift
        ;;
        *)
        echo "Unknown param $1"
        exit 1
        ;;
    esac
done

if [[ $USE_NVIM -eq 1 ]]; then
    VIM="nvim"
    VIM_COMMANDS="$VIM_COMMANDS +UpdateRemotePlugins"
    if [ ! -d "$HOME/.config/nvim" ]; then
        mkdir $HOME/.config/nvim
    fi
fi

tmuxplugins() {
    _update=$1
    echo "Installing tmux plugins..."

    create_dir ${HOME}/.tmux
    create_dir ${HOME}/.tmux/plugins

    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

    if [[ ${_update} -eq 1 ]]; then
        ${HOME}/.tmux/plugins/tpm/scripts/clean_plugins.sh
        ${HOME}/.tmux/plugins/tpm/scripts/update_plugin.sh
        ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
    fi
}

if [ -d "$FOLDER/.git" ]; then
    echo "Copying vimrc"
    safe_rm $HOME/.vimrc
    ln -s ${FOLDER}/vimrc.vim $HOME/.vimrc
    if [[ $USE_NVIM -eq 1 ]]; then
        safe_rm $HOME/.config/nvim/init.vim
        ln -s ${FOLDER}/vimrc.vim $HOME/.config/nvim/init.vim
    fi

    echo "Copying tmux.conf"
    safe_rm $HOME/.tmux.conf
    ln -s ${FOLDER}/tmux.conf $HOME/.tmux.conf

    echo "Copying gitconfig"
    safe_rm $HOME/.gitconfig
    ln -s ${FOLDER}/gitconfig $HOME/.gitconfig

    echo "Copying bash_aliases"
    safe_rm $HOME/.bash_aliases
    # using copy here because links don't work
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

    if [[ $UPDATE_PLUGINS -eq 1 ]]; then
        # update and install all vim plugins
        echo "Installing vim plugins..."
        $VIM $VIM_COMMANDS +qall
    fi

    tmuxplugins $UPDATE_PLUGINS
else
    echo "wrong directory :("
fi
