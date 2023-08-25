# How to activate a config

Install nix, then add home-manager channel:

```bash
# Go to project root, where flake.nix located
cd ..
nix run .#hm-switch <home>

# For example
nix run .#hm-switch homelab
```
