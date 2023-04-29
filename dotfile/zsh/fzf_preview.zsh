__fzf_preview_file() {
  local file="$1"

  if [[ -L "$file" ]]; then
    local target=$(realpath $file)
    _fzf_preview_file $file
  elif [[ -d "$file" ]]; then
    builtin ls -A -F "$file"
  elif [[ -f "$file" ]]; then
    bat --style=numbers --color=always "$file"
  else
    echo "This file cannot be previewed"
  fi
}

__fzf_preview_diff() {
  if [[ -z "$1" ]]; then
    echo "No file"
    return
  fi

  local index=${1[1]}
  local worktree=${1[2]}
  local file=${1[4,-1]}

  if [[ $index = '?' ]]; then
    __fzf_preview_file $file
  elif [[ " DD AU AD UA DU AA UU " =~ " ${index}${worktree} " ]]; then
    git diff --color=always -- $file
  else
    if [[ "$index" != ' ' ]]; then
      if [[ "$index" = 'R' ]]; then
        local splited=(${(@/ -> /)file})
        # Compare the old and the new
        git diff --staged --color=always -- ${splited[1]} ${splited[2]}
        file=${splited[2]}
      else
        git diff --staged --color=always -- $file
      fi
    fi
    if [[ "$worktree" != ' ' ]]; then
      git diff --color=always -- $file
    fi
  fi
}
