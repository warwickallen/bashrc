#!/bin/bash -x

pushd ~

if ! which vim
then
    sudo apt-get install -y vim
fi
git clone https://github.com/warwickallen/vimrc.git
ln -sv vimrc .vim
ln -sv .vimrc vimrc/vim.rc

popd
