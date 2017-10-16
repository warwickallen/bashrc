## "pgrepfi regex" returns the full ps output for commands whose command string
## case-insensitively matches the regex.

function pgrepfi
{
    ps -eopid,args | awk 'BEGIN{IGNORECASE=1} /'"$@"'/ {print $1}' | head -n-1 | xargs -r ps -f
}
