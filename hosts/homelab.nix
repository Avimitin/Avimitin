{ config, ... }:

let
  toSrc = path: { source = ../dotfile/${path}; };
  applyMulSrc = pathes:
    builtins.listToAttrs (map (p: {
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
  xdg.configFile = applyMulSrc [
    "broot/conf.hjson"
    "fish/config.fish"
    "lazygit/config.yml"
    "nix/nix.conf"
    "paru/paru.conf"
    "systemd/user"
  ];
  # xdg.configFile."fish/conf.d/home-manager.fish"
  #   = builtins.toFile "home-manager.fish" ''
  #     alias hm "${config.home} -f ${builtins.toString ./homelab.nix}"
  #   '';
  # xdg.configFile."nvim"
  #   = builtins.fetchGit {
  #     url = "git@github.com:Avimitin/nvim.git";
  #     ref = "master";
  #   };

  programs.home-manager.enable = true;
}
