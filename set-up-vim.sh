#!/bin/bash

pushd ~

sudo apt-get install -y vim
git clone https://github.com/warwickallen/vimrc.git
ln -sv vimrc .vim
ln -sv .vimrc vimrc/vim.rc

popd
