# This nix file contains configuration to used on almost all my machine

{ pkgs, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in {
  home.file = {
    bash = lib.fromDotfile ".bashrc";
    git = lib.fromDotfile ".gitconfig";
    tmux = lib.fromDotfile ".tmux.conf";
  };

  home.packages = with pkgs; [
    delta
    direnv
    neovim
    bat
    fd
    ripgrep
    tmux
  ];

  xdg.configFile = {
    direnv = lib.fromDotfile "direnv/direnvrc";

    fishConf = lib.fromDotfile "fish/config.fish";
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

    neovim = lib.fromDotfile "nvim";
  };

  xdg.dataFile = {
    tmuxJump = lib.fetchTmuxPlugin {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "2ff4940f043cd4ad80fa25c6efa33063fb3b386b";
      sha256 = "sha256-zgFQKQgESThZGoLRjqZGjxeu/C0HMduUOr7jcgELM7s=";
    };
    # We can't install this file to .config/nvim because it is a symlink to nix store
    nvim-treesitter-parsers = {
      # FIXME: Is it better to pin the neovim version instead of refering the local file?
      source = let
        parsers = pkgs.callPackage ../../dotfile/nvim/nix/treesitter-parsers.nix {};
        toNvimPlug = pkgs.callPackage ../../dotfile/nvim/nix/set-rtp.nix {};
      in
        toNvimPlug "treesitter-parsers" (parsers []);
      target = "nvim/site/plugin/treesitter-parsers.lua";
    };
  };

  programs = {
    # Use the version specified in flake
    home-manager.enable = false;
    lsd = {
      enable = true;
      enableAliases = false;
      settings = {
        date = "relative";
        blocks = ["date" "size" "name"];
        # Actually this means 'one-per-line'
        layout = "oneline";
        sorting.dir-grouping = "first";
        ignore-globs = [
          ".git"
          ".hg"
          ".bsp"
        ];
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [ "yellow" "bold" ];
        inactiveBorderColor = [ "white" ];
        selectedLineBgColor = [ "reverse" ];
        selectedRangeBgColor = [ "reverse" ];
      };
      git = {
        commit = {
          signOff = true;
          verbose = "always";
        };
        paging = {
          colorArgs = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
