## "run-as user command [arguemnts]" establishes an SSH connection to
## localhost, logging in as user, and executes command (passing in any
## arguments, if given).  X11 forwarding is enabled, so graphical
## programmes can be launched using this function.  Authentication
## relies on the existance of an accepted RSA private key at
## ~/.ssh/user.rsa.

function run-as
{
  user=$1
  shift
  (
    set -x
    ssh -Xfi"$HOME/.ssh/$user.rsa" "$user@localhost" "$@" >>"$HOME/.run-as.$user.$1.log" 2>&1
  )
}
