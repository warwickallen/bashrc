#!/bin/bash

function xsel-rotate
{
  tmp=/tmp/$$.$(date +%s).
  src=(p s b)
  dst=(b p s)
  for i in 0 1 2
  do
    xsel -o${src[$i]} >$tmp$i
  done
  for i in 0 1 2
  do
    xsel -i${dst[$i]} <$tmp$i
    rm $tmp$i
  done
}
