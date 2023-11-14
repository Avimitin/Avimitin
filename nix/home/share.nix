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
    ruby # Needed by tmux-jump
    nil # Nix language server
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
    tmuxJump = lib.fetchTmuxPlugin {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "2ff4940f043cd4ad80fa25c6efa33063fb3b386b";
      sha256 = "sha256-zgFQKQgESThZGoLRjqZGjxeu/C0HMduUOr7jcgELM7s=";
    };
    # We can't install this file to .config/nvim because it is a symlink to nix store
    nvim-treesitter-parsers = {
      # FIXME: Is it better to pin the neovim version instead of refering the local file?
      source =
        let
          parsers = pkgs.callPackage ../../dotfile/nvim/nix/treesitter-parsers.nix { };
          toNvimPlug = pkgs.callPackage ../../dotfile/nvim/nix/set-rtp.nix { };
        in
        toNvimPlug "treesitter-parsers" (parsers [ ]);
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
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
      format =
        let
          components = [
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "$hg_branch"
            "$nix_shell"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$line_break"
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
      git_status = {
        style = "yellow";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "";
        stashed = "";
        diverged = "";
        untracked = "";
        modified = " ";
        staged = " ";
        renamed = "";
        deleted = "";
      };
    };
  };
}
