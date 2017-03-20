#!/bin/bash

## Short-cut for establishing a VNC connection to an AWS GoCD build agent.
## The first parameter is the agent number; e.g., "229".  The second
## parameter is the VNC display port, which defaults to "1".

function aws-agent-vnc
{
  aws-agent-vnc-open-tunnel "$1" "$2" || return $?
  aws-agent-vnc-connect "$2"
  aws-agent-vnc-close-tunnel "$2"
}

function aws-agent-vnc-open-tunnel
{
  agent=$1
  [ -z "$agent" ] && {
    echo "Please provide the agent number." >&2
    return 1
  }
  display=${2-1}
  tunnel_pid_file=/tmp/aws-agent-vnc-tunnel.${display}
  [ -e ${tunnel_pid_file} ] && {
    echo "${tunnel_pid_file} already exists.  Please close open tunnels on display :${display} and remove the file." >&2
    return 1
  }
  cmd="ssh -i${HOME}/.ssh/gdt-continuous.pem ubuntu@build-server -oCompressionLevel=9 -fNL590${display}:10.0.1.${agent}:5901"
  msg="SSH tunnel to Build Agent ${agent} for VNC display :${display}."
  ${cmd} || {
    retval=$?
    echo "Could not open ${msg} (error code $retval)" >&2
    return $retval
  }
  echo "Opened ${msg}"
  pgrep -f "${cmd}" | tail -1 >${tunnel_pid_file}
}

function aws-agent-vnc-close-tunnel
{
  display=${1-1}
  tunnel_pid_file=/tmp/aws-agent-vnc-tunnel.${display}
  [ -f ${tunnel_pid_file} ] || {
    echo "${tunnel_pid_file} does not exist or is not a regular file." >&2
    return 1
  }
  read tunnel_pid <${tunnel_pid_file}
  kill -9 ${tunnel_pid}
  retval=$?
  rm ${tunnel_pid_file}
  return $(( $? + $retval ))
}

function aws-agent-vnc-connect
{
  display=${1-1}
  vncviewer -autopass :${display} <<<Password
}
