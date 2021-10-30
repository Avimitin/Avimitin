source ~/.config/fish/startup.fish

# Start X at login
#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end

set -x fish_greeting ""

function fish_prompt -d "Write out the prompt"
    set ok $status
    echo
    printf '%s%s%s\n' (set_color cyan) (prompt_pwd) (set_color normal)
    if test $ok -gt 0
      printf '%s %s' (set_color red) (set_color normal)
    else
      printf '%s %s' (set_color green) (set_color normal)
    end
    set -e contents
    set -e ok
end
