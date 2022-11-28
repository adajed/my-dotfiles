#!/bin/bash

if [ $(hash fzf 2>/dev/null; echo $?) -eq 1]; then
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --update-rc
fi

