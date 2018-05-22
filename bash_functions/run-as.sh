## "run-as user command [arguemnts]" establishes an SSH connection to
## localhost, logging in as user, and executes command (passing in any
## arguments, if given).  X11 forwarding is enabled, so graphical
## programmes can be launched using this function.  Authentication
## relies on the existance of an accepted RSA private key at
## ~/.ssh/user.rsa.

function run-as
{
  user=$1
  logdir="$HOME/.run-as"
  mkdir -p "$logdir"
  shift
  (
    set -x
    logname="${logdir}/${user}.$(sed 's,/,~,g'<<<"$1").log"
    ssh -Xfi"$HOME/.ssh/$user.rsa" "$user@localhost" "$@" >>"${logname}" 2>&1
  )
}
