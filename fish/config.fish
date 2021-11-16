source ~/.config/fish/startup.fish

# Start X at login
#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end

set -x fish_greeting ""

function __set_up_user_prompt
    printf "%s%s%s" (set_color brmagenta) $USER (set_color normal)
end

function __set_up_pwd_prompt
    set -g fish_prompt_pwd_dir_length 3
    printf " in %s%s%s" (set_color cyan) (prompt_pwd) (set_color normal)
end

function __set_up_git_prompt
    if git rev-parse > /dev/null 2>&1
      printf ' in %s%s%s' (set_color yellow) (git branch --show-current) (set_color normal)
    end
end

function fish_prompt -d "Write out the prompt"
    set __ok $status
    echo
    __set_up_user_prompt
    __set_up_pwd_prompt
    __set_up_git_prompt
    echo
    if test $__ok -gt 0
      printf '%sx %s' (set_color red) (set_color normal)
    else
      printf '%s> %s' (set_color blue) (set_color normal)
    end
    set -e __ok
end
