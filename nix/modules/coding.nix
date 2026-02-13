{ pkgs, config, flake-inputs, ... }:

let
  myLib = import ../myLib.nix { inherit config; };
in
{
  home.packages = with pkgs; [
    # Misc shell tools
    flake-inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.neovim # my neovim
    tmux # terminal multiplxer
    delta # Beautiful git diff
    fd # find alternative
    fzf # fuzzy finder
    ripgrep # grep alternative
    zoxide # cd alternative
    gh # github cli
    lazygit # git gui

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

  home.file.tmux = myLib.fromDotfile ".tmux.conf";

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

  home.file.bashrc = {
    enable = true;
    source = pkgs.replaceVarsWith {
      name = "bashrc";

      src = ../../dotfile/.bashrc;

      replacements = {
        bash_completion = pkgs.bash-completion;
      };

      # Ensure .bashrc work and correct
      # postInstall = ''
      #   ${pkgs.buildPackages.bash}/bin/bash -n $target
      #   ${pkgs.shellcheck}/bin/shellcheck -x $target
      # '';
    };
    target = ".bashrc";
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile (pkgs.replaceVarsWith {
        name = "config.fish";

        src = ../../dotfile/fish/config.fish;

        replacements = {
          nix_locale_archive = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        };

        postInstall = ''
          ${pkgs.fish}/bin/fish -n "$target"
        '';
      });
    plugins = [
      {
        name = "fishAutoPair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
    ];
  };

  programs.git = {
    enable = true;
    includes = [
      { path = "~/kurisu/dotfile/git/config"; }
    ];
  };
  # my git status script
  xdg.configFile."git/git-status".source = ../../dotfile/git/git-status;
}
