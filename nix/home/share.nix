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
      enable = false;
      source = pkgs.replaceVarsWith {
        name = "bashrc";

        src = ../../dotfile/.bashrc;

        replacements = {
          bash_completion = pkgs.bash-completion;
        };

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
    nixVersions.nix_2_28

    # Misc shell tools
    delta # Beautiful git diff
    neovim-nightly # vim alternative
    fd # find alternative
    fzf # fuzzy finder
    ripgrep # grep alternative
    zoxide # cd alternative
    gh # github cli
    atuin # enhance bash shell history

    fanbox-dl # Pixiv Fanbox Downloader

    # Development
    nixfmt-rfc-style # global formatter for all nix sources
    nil # Nix language server
    prettierd # json formatter
    metals # Scala LSP
    ccls # c/cpp LSP
    lua-language-server # Lua LSP
    stylua # Lua formatter
    pyright # Python LSP
    black # Python fmt
  ];

  nix.package = pkgs.nixVersions.nix_2_28;
  nix.settings = {
    experimental-features = "flakes nix-command pipe-operators";
    bash-prompt-prefix = "(nix:$name)\\040";
  };

  xdg.configFile = {
    fishConf = {
      source = pkgs.replaceVarsWith {
        name = "config.fish";

        src = ../../dotfile/fish/config.fish;

        replacements = {
          nix_locale_archive = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        };

        postInstall = ''
          ${pkgs.fish}/bin/fish -n "$target"
        '';
      };

      target = "fish/config.fish";
    };
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
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      date = "relative";
      blocks = [
        "date"
        "size"
        "name"
      ];
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
}
