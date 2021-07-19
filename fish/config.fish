source ~/.config/fish/startup.fish

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty > ~/.xorg.log 2>&1
    end
end
