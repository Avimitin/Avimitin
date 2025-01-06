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
      source = pkgs.substituteAll {
        src = ../../dotfile/.bashrc;

        bash_completion = pkgs.bash-completion;

        # Ensure .bashrc work and correct
        postInstall = ''
          ${pkgs.buildPackages.bash}/bin/bash -n $target
          ${pkgs.shellcheck}/bin/shellcheck -x $target
        '';
      };
      target = ".bashrc";
    };
    tmux = lib.fromDotfile ".tmux.conf";
    inputrc = lib.fromDotfile ".inputrc";
  };

  # Here are a list of package that doesn't need configuration or configuration are handle manunally
  home.packages = with pkgs; [
    nix

    # Misc shell tools
    delta # Beautiful git diff
    neovim-nightly # vim alternative
    fd # find alternative
    fzf # fuzzy finder
    ripgrep # grep alternative
    zoxide # cd alternative
    gh # github cli
    blesh # enhance bash
    atuin # enhance bash shell history

    # Development
    nixpkgs-fmt # global formatter for all nix sources
    nil # Nix language server
    prettierd # json formatter
    metals # Scala LSP
    ccls # c/cpp LSP
    lua-language-server # Lua LSP
    stylua # Lua formatter
    pyright # Python LSP
    black # Python fmt
  ];

  nix.package = pkgs.nixVersions.nix_2_24;
  nix.settings = {
    experimental-features = "flakes nix-command pipe-operators";
    extra-substituters = "s3://nix?endpoint=simisear.felixc.at:19090&scheme=http";
    extra-trusted-public-keys = "homelab.internal.cache.sh1mar.in:ybM3u9ZuI5VZrvli3Nz7/47aoyXsHa92CNe0NJtHJl4= cache.simisear.felixc.at:OdMciouarCkjO8G358rIpIYmRfCFxos0mkVm7Qk2ikQ=";
  };

  xdg.configFile = {
    fishConf = lib.fromDotfile "fish/config.fish";
    xdgPortal = lib.fromDotfile "xdg-desktop-portal";

    git = lib.fromDotfile "git";

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

  programs.bat = {
    enable = true;
    config = {
      theme = "kanagawa";
    };
    themes = {
      kanagawa = {
        src = ../../dotfile/kanagawa.tmTheme;
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
}
