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
    printf '%s%s%s' (set_color cyan) (prompt_pwd) (set_color normal)
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_color brblue
    set -g __fish_git_prompt_char_dirtystate "ﱐ"
    set -g __fish_git_prompt_color_dirtystate bryellow
    printf '%s' (fish_git_prompt)
    echo
    if test $ok -gt 0
      printf '%s %s' (set_color red) (set_color normal)
    else
      printf '%s %s' (set_color blue) (set_color normal)
    end
    set -e contents
    set -e ok
end
