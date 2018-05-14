#!/bin/bash -x

function mksymlink
{
    file=$1; shift
    link=$1; shift
    if [ -e "$link" ]
    then
        echo "Warning: '$link' already exists" >&2
        ls -lsdp "$link"
    else
        (
            set -x
            ln -sv "$link" "$file"
        )
    fi
}

function git-clone-pull
{
    if ! [ -e "$2" ]
    then
        git clone "$1" "$2"
    fi
    pushd "$2"
    git checkout master
    git pull
    popd
}

pushd ~

if ! which vim
then
    sudo apt-get install -y vim
fi
git-clone-pull https://github.com/warwickallen/vimrc.git
mksymlink vimrc .vim
mksymlink .vimrc vimrc/vim.rc

popd
