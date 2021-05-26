starship init fish | source

export NNN_PLUG='g:lazygit;j:autojump;p:preview-tui-ext;f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export NNN_FCOLORS="0B0B04060006060009060B06"
set --export NNN_FIFO "/tmp/nnn.fifo"

alias ls n

status --is-interactive; and source (jump shell fish | psub)
