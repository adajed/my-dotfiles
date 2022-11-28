#!/bin/bash

# directory of this repo
FOLDER=$(pwd)

# whether to use neovim instead of vim
USE_NVIM=1

# whether to update vim/neovim and tmux plugins
UPDATE_PLUGINS=1

# whether to use zsh instead of bash
USE_ZSH=1

# whether to install ranger
USE_RANGER=1

# whether to install fzf
USE_FZF=1

# whether to install autojump
USE_AUTOJUMP=1

# whether to install language servers
USE_LANGUAGE_SERVER=1

# "vim" for vim and "nvim" for neovim
VIM="nvim"

# check if file exists before removing it
safe_rm() {
    _path=$1
    if [ -f "$_path" ]; then
        rm "$_path"
    fi
}

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h|--help)
            echo "Usage: $0 [--no-nvim] [--no-update] [--no-zsh] [--no-ranger] [--no-fzf] [--no-autojump]"
            echo -e "--no-nvim     - use vim instead of neovim"
            echo -e "--no-update   - don't update vim/nvim plugins"
            echo -e "--no-zsh      - don't install zsh"
            echo -e "--no-ranger   - don't install ranger"
            echo -e "--no-fzf      - don't install fzf"
            echo -e "--no-autojump - don't install autojump"
            echo -e "--no-lsp      - don't install language servers"
            exit 0
        ;;
        --no-nvim)
            USE_NVIM=0
            VIM="vim"
            shift
        ;;
        --no-update)
            UPDATE_PLUGINS=0
            shift
        ;;
        --no-zsh)
            USE_ZSH=0
            shift
        ;;
        --no-ranger)
            USE_RANGER=0
            shift
        ;;
        --no-fzf)
            USE_FZF=0
            shift
        ;;
        --no-autojump)
            USE_AUTOJUMP=0
            shift
        ;;
        --no-lsp)
            USE_LANGUAGE_SERVER=0
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

    if [ ! -f "${VIM_PLUG_PATH}" ] || [ ${UPDATE_PLUGINS} -eq 1 ]; then
        echo "Installing vim-plug"
        curl -fLo ${VIM_PLUG_PATH} --create-dirs ${VIM_PLUG_URL}
    fi
}

tmuxplugins() {
    _update=$1
    echo "Installing tmux plugins..."

    mkdir -p ${HOME}/.tmux/plugins
    if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    fi

    if [[ ${_update} -eq 1 ]]; then
        cd ${HOME}/.tmux/plugins/tpm
        git pull
        cd ${FOLDER}

        ${HOME}/.tmux/plugins/tpm/scripts/clean_plugins.sh
        ${HOME}/.tmux/plugins/tpm/scripts/update_plugin.sh
        ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
    fi
}

check_if_command_exists() {
    _command=$1
    if [ $(hash ${_command} 2>/dev/null; echo $?) -eq 1 ]; then
        echo -e "${_command} is required, but it's not installed. Please install it first."
        exit 1
    fi
}

install_if_does_not_exists() {
    _command=$1
    _package=$2
    if [ $(hash ${_command} 2>/dev/null; echo $?) -eq 1]; then
        apt install ${_package} -y
    fi
}

install_if_does_not_exists git git
install_if_does_not_exists vim vim
install_if_does_not_exists curl curl
install_if_does_not_exists tmux tmux
install_if_does_not_exists ag silversearcher-ag
install_if_does_not_exists rg ripgrep

# if installing for neovim check whether it is installed
if [[ $USE_NVIM -eq 1 ]]; then
    check_if_command_exists nvim
fi

if [ -d "$FOLDER/.git" ]; then
    echo "Copying vimrc"
    if [[ $USE_NVIM -eq 0 ]]; then
        safe_rm $HOME/.vimrc
        ln -s ${FOLDER}/vimrc.vim $HOME/.vimrc
    else
        safe_rm $HOME/.config/nvim/init.vim
        mkdir -p $HOME/.config/nvim
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

    # install vim plugin manager
    install_vim_plug

    if [[ $UPDATE_PLUGINS -eq 1 ]]; then
        # update and install all vim plugins
        echo "Installing vim plugins..."
        $VIM +PlugClean! +PlugUpdate +qall
        tmuxplugins $UPDATE_PLUGINS
    fi

    if [[ $USE_FZF -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_fzf.sh
    fi

    if [[ $USE_RANGER -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_ranger.sh
    fi

    if [[ $USE_ZSH -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_zsh.sh
    fi

    if [[ $USE_AUTOJUMP -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_autojump.sh
    fi

    if [[ $USE_LANGUAGE_SERVER -eq 1 ]]; then
        . ${FOLDER}/scripts/setup_lsp.sh
    fi

    install_if_does_not_exists clang-tidy clang-tidy-14
    install_if_does_not_exists clang-format clang-format-14
else
    echo "wrong directory :("
fi
