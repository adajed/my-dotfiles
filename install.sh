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
VIM_COMMANDS="+PlugClean! +PlugUpdate"

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h)
            echo "Usage: $0 [--nvim] [--noupdate]"
            echo -e "--nvim     - use neovim instead of vim (neovim must be already installed)"
            echo -e "--noupdate - don't update vim/nvim plugins"
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
    create_dir $HOME/.config/nvim
fi

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
    if [ ! -f "${VIM_PLUG_PATH}" ]; then
        echo "Downloading vim-plug..."
        install_vim_plug
    else
        echo "vim-plug is already installed"
    fi

    if [[ $UPDATE_PLUGINS -eq 1 ]]; then
        # update and install all vim plugins
        echo "Installing vim plugins..."
        $VIM $VIM_COMMANDS +qall
        tmuxplugins $UPDATE_PLUGINS
    fi

else
    echo "wrong directory :("
fi
