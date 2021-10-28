function n --wraps nnn --description 'support nnn quit and change directory'
    # test nnn exist
    if not type nnn 2>&1 >/dev/null
      echo "nnn not found"
    end

    # Block nesting of nnn in subshells
    if test -n "$NNNLVL"
        if [ (expr $NNNLVL + 0) -ge 1 ]
            echo "nnn is already running"
            return
        end
    end

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "-x" as in:
    #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    if test -n "$XDG_CONFIG_HOME"
        set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    else
        set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    end

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # nnn settings
    set -x ICONLOOKUP       1
    set -x NNN_PLUG_GIT     'g:mine/lazygit;d:diffs'
    set -x NNN_BMS          "e:$HOME/Codes;h:$HOME;d:$HOME/Documents;c:$HOME/.config;D:$HOME/Downloads/"
    set -x NNN_PLUG_EXPLORE 'j:autojump;f:fzcd;o:fzopen'
    set -x NNN_PLUG_FILE    't:nmount;k:nuke;n:mine/neovide-remote;u:mine/nvui-remote'
    set -x NNN_PLUG_VIEW    'v:imgview;p:preview-tui;P:preview-tabbed;w:mine/wallpaper'
    set -x NNN_PLUG         "$NNN_PLUG_GIT;$NNN_PLUG_EXPLORE;$NNN_PLUG_FILE;$NNN_PLUG_VIEW"
    set -x NNN_FCOLORS      "0B0B04060006060009060B06"
    set -x NNN_FIFO         "/tmp/nnn.fifo"

    # exercute
    nnn -e $argv

    if test -e $NNN_TMPFILE
        source $NNN_TMPFILE
        rm $NNN_TMPFILE
    end
end

