# ========================================================================================================
# FZF Setup
# ========================================================================================================
export FZF_COMPLETION_TRIGGER=''

if (( $+commands[fd] )); then
  _fd_argument=('--type f' '--hidden' '--strip-cwd-prefix' '--follow'
                '--max-depth 1'
                '--exclude .git'
                "--exclude '*.pyc'"
                '--exclude target/debug'
                '--exclude target/release')

  export FZF_DEFAULT_COMMAND="fd ${_fd_argument[*]}"
  export FZF_CTRL_T_COMMAND="fd ${_fd_argument[*]}"

  unset _fd_argument
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
fi

_fzf_opts=(
  '--cycle'
  '--layout=reverse'
  '--border'
  '--height=65%'
  '--preview-window=wrap'
  '--marker="*"'
)

export FZF_DEFAULT_OPTS="${_fzf_opts[*]}"

if (( ${+commands[bat]} )); then
  _fzf_opts=("--preview 'bat -n --color=always {}'"
    "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ${_fzf_opts[*]})
fi
export FZF_CTRL_T_OPTS="${_fzf_opts[*]}"

if [[ -d "/usr/share/fzf" ]]; then
  local fzf_dir="/usr/share/fzf"
  source "${fzf_dir}/completion.zsh"
  source "${fzf_dir}/key-bindings.zsh"
fi

__fzf_search_git_status() {
  if not git rev-parse --git-dir &> /dev/null; then
    echo "Not in git respository" >&2
  else
    local selected_path="$(git -c color.status=always status --short | fzf --ansi --multi --preview='source $ZDOTDIR/fzf_preview.zsh && __fzf_preview_diff {}')"
    # split line by newline, and we can have array of " M xxx"
    # https://git-scm.com/docs/git-status/2.35.0#_short_format
    local splited_status=(${(f)selected_path})
    if (( $? == 0 )); then
      local escaped=()
      for p in ${splited_status[@]}; do
        # path has been renamed and looks like " R plugin -> plugins"
        if [[ "${p[2]}" = "R" ]]; then
          local splited=(${(@s/ -> /)p})
          escaped+="${splited[-1]}"
        else
          escaped+="$p[4,-1]"
        fi
      done
      echo "${escaped[@]}"
    fi

    local ret=$?
    echo
    return $ret
  fi
}

fzf_search_git_status() {
  LBUFFER="${LBUFFER}$(__fzf_search_git_status)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N fzf_search_git_status
bindkey '^S' fzf_search_git_status
