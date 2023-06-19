{ config, pkgs, ... }:

with builtins;

let
  toSrc = path: { source = ../dotfile/${path}; };
  toMulSrc = pathes:
    listToAttrs (map (p: {
      name = p;
      value = toSrc p;
    }) pathes);
in {
  home = {
    username = "i";
    homeDirectory = "/home/i";
    stateVersion = "23.05";
    file = {
      ".bashrc" = toSrc "bash/.bashrc";
      ".gitconfig" = toSrc "git/.gitconfig";
      ".tmux.conf" = toSrc "tmux/.tmux.conf";
    };
  };
  # Symlink file only to avoid program write some unexpected stuff into directory.
  xdg.configFile = (toMulSrc [
    "broot/conf.hjson"
    "fish/config.fish"
    "lazygit/config.yml"
    "nix/nix.conf"
    "paru/paru.conf"
    "systemd/user"
    "nvim"
  ]) // {
    # I really hate nixpkgs, for now.
    # So I don't want to add $HOME/.nix-profile/bin into $PATH, as it will pollute my environment.
    # The below fish script will create an alias `hm` to help me execute the home-manager.
    # Also, it force the home-manager to use this nix file to avoid any other possible problem.
    "fish/conf.d/home-manager.fish" = {
      source = (pkgs.writeTextFile {
        name = "home-manager.fish";
        text = ''
          alias hm "${config.home.path}/bin/home-manager -f ${
            toString ./homelab.nix
          }"'';
      });
    };
  };

  programs.home-manager.enable = true;
}
