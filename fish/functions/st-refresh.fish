function st-refresh
  set xresource $argv
  if test -z $xresource
    set xresource "$HOME/.Xresources"
  else
    set prefix "$HOME/.config/Xresources"
    set xresource "$prefix/$xresource"
    if not test -r $xresource
      echo "No xresources named $xresource was found"
      return 1
    end
  end

  xrdb -merge $xresource && kill -USR1 (pidof st | string split ' ')
end

complete -c st-refresh -x -a "(ls '$HOME/.config/Xresources')"
