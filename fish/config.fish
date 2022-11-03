# ===================================================================
# keybinding
# ===================================================================

# enable vi keybind
# set -g fish_key_bindings fish_vi_key_bindings

# set my keybind
# bind -M default 'H' beginning-of-line
# bind -M visual 'H' beginning-of-line
# bind -M default 'L' end-of-line
# bind -M visual 'L' end-of-line
# bind -M insert '\e;' escape

# ===================================================================
# fish settings
# ===================================================================
set -x fish_greeting ""

# Hydro prompt settings
set -g hydro_symbol_prompt ''
set -g hydro_symbol_git_dirty ' '
set -g hydro_symbol_git_ahead ' '
set -g hydro_symbol_git_behind ' '
set -g fish_prompt_pwd_dir_length 2

# Use gpg-agent to replace ssh-agent
if command -q gpgconf && test -n "$DISPLAY"
  set -x GPG_TTY (tty)
  set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
end
