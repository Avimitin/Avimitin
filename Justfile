# Justfile

set shell := ["bash", "-c"]

# Common flags for Nix and Home Manager
nix_flags := '--extra-experimental-features "flakes nix-command" --no-warn-dirty'
hm_flags := '--extra-experimental-features "flakes nix-command" -j auto'

# Offline mode control (default to true)
offline := "true"
nix_offline := if offline == "true" { "--offline" } else { "" }
hm_offline := if offline == "true" { "--no-substitute" } else { "" }

# Default recipe: List available commands
default:
    @just --list

# Run any command in online mode
# Usage: just online <command> [args...]
# Example: just online switch my-machine
online *args:
    @just offline=false {{args}}

# Switch to a home configuration (Offline by default)
# Usage: just switch <name> [args...]
# For online mode: just online switch <name> [args...]
# Alternative: just offline=false switch <name> [args...]
# Example: just switch my-machine --show-trace
alias s := switch
switch name *args:
    nix {{nix_flags}} {{nix_offline}} run '.#home-manager' -- {{hm_flags}} {{hm_offline}} --flake ".#{{name}}" switch {{args}}

# Update and Switch (Online)
# Updates flake.lock first, then switches
# Usage: just update <name> [args...]
alias u := update
alias up := update
update name *args:
    nix flake update --commit-lock-file --commit-lock-file-summary "nix: bump flake.nix"
    nix {{nix_flags}} run '.#home-manager' -- {{hm_flags}} --flake ".#{{name}}" switch {{args}}

# Clean old generations
# Usage: just clean
alias expire := clean
clean *args:
    nix {{nix_flags}} {{nix_offline}} run '.#home-manager' -- {{hm_flags}} {{hm_offline}} expire-generations {{args}}

# List generations
# Usage: just list
alias l := list
list *args:
    nix {{nix_flags}} {{nix_offline}} run '.#home-manager' -- {{hm_flags}} {{hm_offline}} generations {{args}}

# Run arbitrary home-manager commands
# Usage: just run <command> [args...]
run cmd *args:
    nix {{nix_flags}} {{nix_offline}} run '.#home-manager' -- {{hm_flags}} {{hm_offline}} {{cmd}} {{args}}
