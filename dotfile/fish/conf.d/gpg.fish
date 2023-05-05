# Use gpg-agent to replace ssh-agent
if command -q gpgconf
  set -gx GPG_TTY (tty)
  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
end
