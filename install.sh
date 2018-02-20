#!/bin/bash

project_dir=$(pwd)

echo "so ${project_dir}/vimrc.vim" > ~/.vimrc
echo "so ${project_dir}/tmux.conf" > ~/.tmux.conf

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
fi

# update and install all vim plugins
vim +PluginClean! +PluginUpdate +PluginInstall +qall
python3 ~/.vim/bundle/youcompleteme/install.py --clang-completer
