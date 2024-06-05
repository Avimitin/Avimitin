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
    bash = {
      source = lib.substituted { BASH_COMPLETION = pkgs.bash-completion; } ../../dotfile/.bashrc;
      target = ".bashrc";
    };
    git = lib.fromDotfile ".gitconfig";
    tmux = lib.fromDotfile ".tmux.conf";
  };

  # Here are a list of package that doesn't need configuration or configuration are handle manunally
  home.packages = with pkgs; [
    # Misc shell tools
    delta # Beautiful git diff
    direnv # Shell hook for nix flake used only
    neovim-nightly # vim alternative
    bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative
    zoxide # cd alternative
    broot # fuzzy search based file manager
    gh # github cli

    # Development
    nixpkgs-fmt # global formatter for all nix sources
    nil # Nix language server
    pyright # Python language server
    black # Python formatter
    ghc # I need ghci
    haskellPackages.fourmolu # Haskell formatter
    # Use the project devShell provided one
    # nodePackages.typescript-language-server # For frontend development
    prettierd # js/ts formatter
    metals # Scala LSP
    clang-tools # Contains clangd
    lua-language-server # Lua LSP
    stylua # Lua formatter
    solargraph # Ruby language server
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "flakes nix-command";
    extra-substituters = "s3://nix?endpoint=simisear.felixc.at:19090&scheme=http";
    extra-trusted-public-keys = "homelab.internal.cache.sh1mar.in:ybM3u9ZuI5VZrvli3Nz7/47aoyXsHa92CNe0NJtHJl4= cache.simisear.felixc.at:OdMciouarCkjO8G358rIpIYmRfCFxos0mkVm7Qk2ikQ=";
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

    neovim = {
      source = pkgs.my-nvim-src;
      target = "nvim";
    };
  };

  xdg.dataFile = {
    tmux-thumbs = {
      source = "${pkgs.tmux-fingers}/${pkgs.tmux-fingers.tmux-script}";
      target = "tmux/plugins/tmux-fingers/tmux-fingers.tmux";
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
      customCommands = [
        {
          key = "F";
          context = "global";
          command = "git fetch --all --prune --prune-tags --force";
          loadingText = "Force fetching all branches.";
        }
      ];
      gui = {
        showRamdomTip = false;
        showBottomLine = false;
        theme = {
          activeBorderColor = [ "yellow" "bold" ];
          inactiveBorderColor = [ "white" ];
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
        nerdFontsVersion = "3";
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
        log = {
          showGraph = "when-maximised";
        };
        notARepository = "skip";
      };
    };
  };

  # Prompt for bash
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[➜](blue)";
        error_symbol = "[➜](bold red)";
      };
      format =
        let
          components = [
            "$directory"
            "$nix_shell"
            "$git_branch"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$hostname"
            "$line_break"
            "$jobs"
            "$character"
          ];
        in
        "${builtins.concatStringsSep "" components}";
      directory.fish_style_pwd_dir_length = 1;
      nix_shell.symbol = "󱄅 ";
      git_branch.format = "[\\($branch(:$remote_branch)\\)]($style) ";
      hostname = {
        ssh_symbol = "󰌘";
        format = "in [$ssh_symbol]($style) [$hostname](bright-green)";
      };
    };
  };
}
