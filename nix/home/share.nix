# This nix file contains configuration to used on almost all my machine

{ pkgs, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in
{
  # Use the one define in nix flake
  programs.home-manager.enable = false;
  # Don't notify news
  news.display = "silent";

  home.file = {
    bash = lib.fromDotfile ".bashrc";
    git = lib.fromDotfile ".gitconfig";
    tmux = lib.fromDotfile ".tmux.conf";
  };

  # Here are a list of package that doesn't need configuration or configuration are handle manunally
  home.packages = with pkgs; [
    delta # Beautiful git diff
    direnv # Shell hook for nix flake used only
    neovim # vim alternative
    bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative
    tmux # Terminal windows manager
    zoxide # cd alternative
    nil # Nix language server
    pyright # Python language server
    nixpkgs-fmt # global formatter for all nix sources
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "flakes nix-command repl-flake";
    extra-trusted-public-keys = "homelab.internal.cache.sh1mar.in:ybM3u9ZuI5VZrvli3Nz7/47aoyXsHa92CNe0NJtHJl4=";
  };

  xdg.configFile = {
    direnv = lib.fromDotfile "direnv/direnvrc";

    fishConf = lib.fromDotfile "fish/config.fish";
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
    # We can't install this file to .config/nvim because the whole nvim directory is a symlink to nix store
    nvim-treesitter-parsers =
      let
        pkg = pkgs.nvim-treesitter-parsers;
      in
      {
        source = "${pkg}${pkg.passthru.luaScript}";
        target = "nvim/site/plugin/treesitter-parsers.lua";
      };
  };

  programs.lsd = {
    enable = true;
    enableAliases = false;
    settings = {
      date = "relative";
      blocks = [ "date" "size" "name" ];
      # Actually this means 'one-per-line'
      layout = "oneline";
      sorting = {
        dir-grouping = "first";
        column = "time";
      };
      ignore-globs = [
        ".git"
        ".hg"
        ".bsp"
      ];
    };
    colors = {
      date = {
        day-old = "green";
        older = "dark_green";
      };
      size = {
        none = "grey";
        small = "grey";
        medium = "yellow";
        large = "dark_yellow";
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

  # Prompt for bash
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[](green)";
        error_symbol = "[](bold red)";
      };
      format =
        let
          components = [
            "$hostname"
            "$directory"
            "$nix_shell"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$jobs"
            "$character"
          ];
        in
        "${builtins.concatStringsSep "" components}";
      nix_shell.symbol = "󱄅 ";
      hostname = {
        ssh_symbol = "󰌘";
        format = "[$ssh_symbol]($style) ";
      };
    };
  };
}
