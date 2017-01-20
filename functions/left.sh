## "left n" truncates each line of standard inut to n characters. "left"
## (with no character count) truncates each line of standard input to fit
## in the current terminal.

function left
{
    cut -c1-${1-$(tput cols)}
}
