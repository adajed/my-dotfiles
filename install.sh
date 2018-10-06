#!/bin/bash

# directory of this repo
FOLDER=$(pwd)
# set to 1 use neovim instead of vim
USE_NVIM=0
# whether to update vim/neovim and tmux plugins
UPDATE_PLUGINS=1
# "vim" for vim and "nvim" for neovim
VIM="vim"
# set to 1 to install zsh
USE_ZSH=0

# check if file exists before removing it
safe_rm() {
    _path=$1
    if [ -f "$_path" ]; then
        rm "$_path"
    fi
}

# check if file directory exists and if not create it
create_dir() {
    _path=$1
    if [ ! -d "${_path}" ]; then
        mkdir ${_path}
    fi
}


while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h)
            echo "Usage: $0 [--nvim] [--noupdate]"
            echo -e "--nvim     - use neovim instead of vim (neovim must be already installed)"
            echo -e "--noupdate - don't update vim/nvim plugins"
            echo -e "--zsh      - install zsh"
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
        --zsh)
            USE_ZSH=1
            shift
        ;;
        *)
        echo "Unknown param $1"
        exit 1
        ;;
    esac
done

install_vim_plug() {
    VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    if [[ ${USE_NVIM} -eq 1 ]]; then
        VIM_PLUG_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"
    else
        VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"
    fi
    curl -fLo ${VIM_PLUG_PATH} --create-dirs ${VIM_PLUG_URL}
}

tmuxplugins() {
    _update=$1
    echo "Installing tmux plugins..."

    create_dir ${HOME}/.tmux
    create_dir ${HOME}/.tmux/plugins

    if [ ! -d "${HOME}/.tmux/plugins" ]; then
        git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    fi

    if [[ ${_update} -eq 1 ]]; then
        ${HOME}/.tmux/plugins/tpm/scripts/clean_plugins.sh
        ${HOME}/.tmux/plugins/tpm/scripts/update_plugin.sh
        ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
    fi
}

if [ -d "$FOLDER/.git" ]; then
    echo "Copying vimrc"
    if [[ $USE_NVIM -eq 0 ]]; then
        safe_rm $HOME/.vimrc
        ln -s ${FOLDER}/vimrc.vim $HOME/.vimrc
    else
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
    ln -s ${FOLDER}/bash_aliases $HOME/.bash_aliases

    if [[ $UPDATE_PLUGINS -eq 1 ]]; then
        # update and install all vim plugins
        echo "Installing vim plugins..."
        $VIM +PlugClean! +PlugUpdate +qall
        tmuxplugins $UPDATE_PLUGINS
    fi

    if [[ $USE_ZSH -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_zsh.sh
    fi

else
    echo "wrong directory :("
fi
