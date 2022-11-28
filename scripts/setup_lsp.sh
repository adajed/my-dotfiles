#!/bin/bash -x

# setup pyls
pip3 install 'python-language-server[all]'

# setup clangd
apt install clangd-12 -y

# setup compiledb
pip3 install compiledb

# setup bash
npm i -g bash-language-server
