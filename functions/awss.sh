## Short-cut for establishing an SSH connection to an AWS EC2 instance.
## The first parameter is an identifier to the PEM key.  It should contain
## enough of the key's kile name to unquiely identify it out of the keys,
## this is files with a ".pem" extention, in the ~/.ssh directory.  The
## second parameter is the address.  It can be a URL or and IP address,
## or if it starts with a "-" a URL will be constructed using the key name
## prepended to the second parameter.  If the second parameter is missing,
## the key name will be used as the URL.

function awss
{
  key=$1; shift
  host=$1; shift
  __awss__ls__ () { $(which ls) -1 $HOME/.ssh/$key*.pem 2>/dev/null; }
  (
    case $(__awss__ls__ | wc -l) in
    0)
      echo "Could not find a key file for '$key'" >&2
      exit 1
      ;;
    1)
      key=$(__awss__ls__)
      key_name=$(sed -e's/^.*\///' -'es/\.pem$//' <<< $key)
      if [ -z "$host" ]
      then
        host=$key_name
      elif [ "${host:0:1}" == "-" ]
      then
        host=$key_name$host
      fi
      (
        set -x
        ssh -i$key ubuntu@$host "$@"
      )
      ;;
    *)
      echo "Found multiple possible key files for '$key':"
      __awss__ls__
      exit 1
      ;;
    esac
  )
  unset __awss__ls__
}
