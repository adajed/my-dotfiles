#!/bin/bash

echo -e "Downloading clangd..."
sudo apt install clang-tools-7

echo -e "Downloading pyls..."
sudo pip3 install python-language-server
