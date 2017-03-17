## "pgrepf regex" returns the full ps output for commands whose command string
## matches the regex.  Options are passed through to pgrep.

function pgrepf
{
    pgrep -f "$@" | xargs -r ps -f
}
