## "cl dir" changes directory to dir then lists its contents.  If any
## options are provided, they are passed to the ls command.

function cl
{
    opts=()
    not_opts=()
    no_more_opts=false
    for param in "$@"
    do
      if ! $no_more_opts && [[ ${param:0:1} == "-" ]]
      then
        if [[ $param == "-" ]]
        then
          no_more_opts=true
        else
          opts+=($param)
        fi
      else
        not_opts+=($param)
      fi
    done
    case ${#not_opts[@]} in
      0)  dir=.
          ;;
      1)  dir=${not_opts[0]}
          ;;
      *)  dir=${not_opts[0]}
          unset not_opts[0]
          echo "Warning: Ignoring extra parameters: ${not_opts[@]}" >&2
          ;;
    esac
    cd "$dir" && \
    ls -l "${opts[@]}"
}
