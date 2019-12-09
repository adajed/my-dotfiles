FROM ubuntu:18.04

WORKDIR /shared/my-dotfiles

RUN    apt update -y \
    && apt install git vim curl tmux software-properties-common -y \
    && add-apt-repository ppa:neovim-ppa/stable -y \
    && apt update -y \
    && apt install neovim python3-dev python3-pip -y

RUN useradd -ou 0 -g 0 -m sampleuser

USER sampleuser

CMD ["/bin/bash", "./install.sh", "--nvim", "--zsh", "--ranger"]
