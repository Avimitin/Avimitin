# Use gpg-agent to replace ssh-agent
if command -q gpgconf
  if test -z "$SSH_CLIENT" && test -z "$SSH_TTY"
    set -gx GPG_TTY (tty)
    gpgconf --launch gpg-agent
  end

  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
