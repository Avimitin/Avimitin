function paste_vimcn --description 'read file and paste it to https://cfp.vim-cn.com/'
  if test -z "$argv"
    echo "Usage: paste-vim <file>"
    return
  end

  cat "$argv" | curl -F 'vimcn=<-' "https://cfp.vim-cn.com/"
end
