#!/bin/bash

function xsel-pipe
{
  help="

xsel-pipe <direction> <buffer>
  Writes the contents of an X11 buffer to a named pipe, or
  writes the contents of a named pipe to an X11 buffer.  The
  named pipe is accessible to all users, so take care with
  sensitive information.

  Parameters:
    direction   'r' to read from a buffer and write to a pipe.
                'w' to read from a pipe and write to a buffer.

    buffer      The X11 buffer to use.  Should be one of:
                  'p' for the primary buffer,
		  's' for the secondary buffer, or
		  'b' for the clipboard.
"
  
  case "$1" in
    [rw]) to_pipe=$([ $1 = "r" ]); ;;
    *) echo "Please enter 'r' or 'w' for the first parameter.$help" >&2; return 1
  esac
  bufname="${2:-b}"
  case $bufname in
    [psb]) ;;
    *) echo "Please enter 'p', 's' or 'b' for the second parameter.$help" >&2; return 1
  esac
  
  fifo=~/.xsel-pipe.$bufname
  if [ -e $fifo ]
  then
    if [ ! -p $fifo ]
    then
      echo "'$fifo' exists but is not a named pipe" >&2
      return 1
    fi
  else
    mkfifo $fifo
  fi
  chmod a+rw $fifo

  if $to_pipe
  then
    nohup xsel -o${bufname:0:1} >$fifo 2>$fifo.log </dev/null &
  else
    nohup xsel -i${bufname:0:1} <$fifo 2>$fifo.log </dev/null &
  fi
}
