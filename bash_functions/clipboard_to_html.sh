## Wraps some HTML around the contents of /dev/clipboard and
## prints it to STDOUT.  This is designed for code snippets
## so uses a fixed-width typeface.

function clipboard_to_html
{
  cat <(
  cat <<HERE
<html>
<body>
<div style="
    background-color: #DDF;
    border: 3px ridge #CCE;
    border-radius: 3px;
    padding: 2px 4px;
    color: #220;
    width: 1600px;
    overflow: scroll;
  ">
<pre>
HERE
  ) <(
  sed \
    -e's,&,\&amp;,g' \
    -e's,<,\&lt;,g' \
    -e's,>,\&gt;,g' \
    -e's, ,\&nbsp;,g' \
    -e's,^,<span style="font-family:monospace">,' \
    -e's,$,</span>,' \
    /dev/clipboard
  ) <(cat <<HERE
</pre>
</div>
</body>
</html>
HERE
  )
}
