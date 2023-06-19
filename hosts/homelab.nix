{ ... }:

let
  toSrc = path: {
    source = path;
  };
in
{
  home = {
    username = "i";
    homeDirectory = "/home/i";
    stateVersion = "23.05";
    file = {
      ".bashrc" = toSrc ./bash/.bashrc;
      ".gitconfig" = toSrc ./git/.gitconfig;
      ".tmux.conf" = toSrc ./tmux/.tmux.conf;
    };
  };
  # Symlink file only to avoid program write some unexpected stuff into directory.
  xdg.configFile = {
    "broot/conf.hjson" = toSrc ./broot/conf.hjson;
    "fish/config.fish" = toSrc ./fish/config.fish;
    "lazygit/config.yml" = toSrc ./lazygit/config.yml;
    "nix/nix.conf" = toSrc ./nix/nix.conf;
    "paru/paru.conf" = toSrc ./paru/paru.conf;
    "systemd/user" = toSrc ./systemd/user;
  };

  programs.home-manager.enable = true;
 }
