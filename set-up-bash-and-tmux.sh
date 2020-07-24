#!/bin/bash -x

if [ -e ~/.bashrc ]
then
  echo "Set up bash and tmux aborted: ~/.bashrc already exists." >&2
else
  ln -svf $(pwd)/bashrc.sh ~/.bashrc

  for i in \
    bash_aliases    \
    bash_functions  \
    tmux-launch-sessions \
    tmux.conf
  do
    if [ ! -e ~/.$i ]
    then
      ln -sv $(pwd)/$i ~/.$i
    fi
  done
fi

if ! which tmux
then
    sudo apt-get install tmux
fi
