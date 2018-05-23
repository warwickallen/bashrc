## "run-as user command [arguemnts]" establishes an SSH connection to
## localhost, logging in as user, and executes command (passing in any
## arguments, if given).  X11 forwarding is enabled, so graphical
## programmes can be launched using this function.  Authentication
## relies on the existance of an accepted RSA private key at
## ~/.ssh/user.rsa.

function run-as
{
  # Parse parameters.
  no_more_options=false
  use_xpra=false
  user=""
  cmd=""
  params=""
  while [ $# -gt 0 ]
  do
    if [ "$1" = "--" ]
    then
      no_more_options=true
    elif [ "$no_more_options" = true ] || [ "${1:0:1}" != "-" ] && [ "${1:0:1}" != "+" ]
    then
      if [ -z "$user" ]
      then
        user="$1"
      elif [ -z "$cmd" ]
      then
        cmd="$1"
        no_more_options=true
      else
        params="$params $1"
      fi
    elif [ "$1" = "-x" ] || [ "$1" = "--xpra" ]
    then
      use_xpra=true
    elif [ "$1" = "+x" ] || [ "$1" = "--no-xpra" ]
    then
      use_xpra=false
    fi
    shift
  done

  logdir="$HOME/.run-as"
  mkdir -p "${logdir}"
  (
    logname="${logdir}/${user}.$(sed 's,/,~,g'<<<"${cmd}").log"
    function _ssh
    {
      set -x
      ssh -i"$HOME/.ssh/${user}.rsa" "${user}@localhost" "$@" >>"${logname}" 2>&1
    }
    if [ $use_xpra = true ]
    then
      tcp_port=$(( $$ % 0x3000 + 0x1000 ))
      _ssh xpra start --bind-tcp localhost:${tcp_port} :${tcp_port} --start "'${cmd} ${params}'"
      sleep 1
      nohup xpra attach tcp:localhost:${tcp_port} >>"${logname}" 2>&1 &
    else
      _ssh -Xf ${cmd} ${params}
    fi
  )
}
