# This nix file contains configuration to used on almost all my machine

{ pkgs, config, ... }:

let
  lib = import ../lib.nix { inherit pkgs config; };
in
{
  # Use the one define in nix flake
  programs.home-manager.enable = false;
  # Don't notify news
  news.display = "silent";

  home.file = {
    bashrc = {
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
    my-neovim # vim alternative
    fd # find alternative
    fzf # fuzzy finder
    ripgrep # grep alternative
    zoxide # cd alternative
    gh # github cli
    lazygit # git gui

    fanbox-dl # Pixiv Fanbox Downloader

    # Development
    nixfmt # global formatter for all nix sources
    nil # Nix language server
    prettierd # json formatter
    metals # Scala LSP
    ccls # c/cpp LSP
    lua-language-server # Lua LSP
    stylua # Lua formatter
    pyright # Python LSP
    ruff # Python fmt
    uv # Python package manager
    tinymist # Typst LSP w/ preview
    nix-output-monitor # Pipe nix output for monitor
    just # Just a command executor

    # AI stuff
    claude-code
    gemini-cli
    opencode
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
