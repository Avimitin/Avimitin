source ~/.config/fish/startup.fish

# Start X at login
#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end

set -x fish_greeting ""

if command -q cowsay and command -q lolcat
  cowsay "What a great day" | lolcat
end
