{ pkgs, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in
{
  home = {
    username = "sh1marin";
    homeDirectory = "/home/sh1marin";
    stateVersion = "23.05";
  };

  home.file = {
    bash = lib.fromDotfile ".bashrc";
    git = lib.fromDotfile ".gitconfig";
    tmux = lib.fromDotfile ".tmux.conf";
  };

  xdg.configFile = {
    neovim = lib.fromDotfile "nvim";
    systemdServices = lib.fromDotfile "systemd/user";
    paru = lib.fromDotfile "paru/paru.conf";
    nix = lib.fromDotfile "nix/nix.conf";
    lazygit = lib.fromDotfile "lazygit/config.yml";
    direnv = lib.fromDotfile "direnv/direnvrc";
    fishConf = lib.fromDotfile "fish/config.fish";
    broot = lib.fromDotfile "broot/conf.toml";
    fontconfig = lib.fromDotfile "fontconfig/conf.d";
    wezterm = lib.fromDotfile "wezterm/wezterm.lua";
    fishPrompt = lib.fetchFishPlugin {
      owner = "jorgebucaran";
      repo = "hydro";
      rev = "41b46a05c84a15fe391b9d43ecb71c7a243b5703";
      sha256 = "sha256-zmEa/GJ9jtjzeyJUWVNSz/wYrU2FtqhcHdgxzi6ANHg=";
    };
    fishAutoPair = lib.fetchFishPlugin {
      owner = "jorgebucaran";
      repo = "autopair.fish";
      rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
      sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
    };
    fishFzf = lib.fetchFishPlugin {
      owner = "PatrickF1";
      repo = "fzf.fish";
      rev = "c5e170730b4f8395e116d7c06883ed53da2d5561";
      sha256 = "sha256-xWaMd5POCDeeFTsGtHbIvsPelIp+GZPC1X1CseCo3BA=";
    };
  };

  xdg.dataFile = {
    tmuxJump = lib.fetchTmuxPlugin {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "2ff4940f043cd4ad80fa25c6efa33063fb3b386b";
      sha256 = "sha256-zgFQKQgESThZGoLRjqZGjxeu/C0HMduUOr7jcgELM7s=";
    };
  };

  programs.home-manager.enable = false;
}