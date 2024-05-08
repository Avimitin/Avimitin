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
    # Misc shell tools
    delta # Beautiful git diff
    direnv # Shell hook for nix flake used only
    neovim # vim alternative
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
    experimental-features = "flakes nix-command repl-flake";
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
      source = (pkgs.callPackage ./_sources/generated.nix { }).nvim.src;
      target = "nvim";
    };
  };

  xdg.dataFile = {
    # We can't install this file to .config/nvim because the whole nvim directory is a symlink to nix store
    # TODO: embedded this into neovim wrapper
    nvim-treesitter-parsers =
      let
        tsLoader = pkgs.generate-nvim-treesitter-parsers [
          { name = "bash"; hash = "sha256-24tPIgyB94eZufGv5BNtDpwj3+K9nbqTJzW7wI12mqY="; }
          { name = "beancount"; hash = "sha256-4KQUwv3PDJPBChLhDSXJpKNUrzUPOk1o9Bs6Z2Tq8+Q="; }
          { name = "c"; hash = "sha256-PMyML+nO9q8G2vpmRKmr0xbBqvO1LW+jIMtrFBaZZ9g="; }
          { name = "cpp"; hash = "sha256-G0hXG83d6MiSXklh5f1Xncmq4mTGtlm4a6JtlRCqvlA="; }
          { name = "css"; hash = "sha256-wu+mjyBNvIgZAEL36CqXQntbGq9qizQUzhzb86bKSU8="; }
          { name = "diff"; hash = "sha256-K4ybmnit3POCWRw8JmS48DyfZXQ7BV0/e7yn6jlg6ss="; }
          { name = "firrtl"; hash = "sha256-xrh8XlgcFz+Z1Rh7z1KZWV26RE65hVtIKjw9XPZaXuA="; }
          { name = "gitcommit"; hash = "sha256-j+W3wmSKTEXAB/LyOnBvzNx4CptQ+JplJ3IVQzs86ss="; }
          { name = "haskell"; hash = "sha256-BTGCx4ZtEBRunCUGufoiPBZ6U0AhGpT56mOQ37UwvoA="; }
          { name = "javascript"; hash = "sha256-Wcg6hzSJHFMApKs82vYlrAP1wVF1XKHgyCg9JfFpMBU="; }
          { name = "typescript"; hash = "sha256-9pvCu2u1+9zCtupDaDZKnIr5ZW58EtKs4VOX6OuRCqA="; srcRoot = "typescript"; }
          { name = "tsx"; hash = "sha256-9pvCu2u1+9zCtupDaDZKnIr5ZW58EtKs4VOX6OuRCqA="; srcRoot = "tsx"; }
          { name = "typst"; hash = "sha256-cMLiXG/74s6PIMXtZfuuKryw34PqBbaT4Ahq1n3w/WY="; }
          { name = "llvm"; hash = "sha256-c63jN6pyIssjthp+3f5pYWMwUq+usjhlP2lF/zVNdc8="; }
          { name = "lua"; hash = "sha256-jGCiNmY35QYqWga5xOSvds0Vo9Kw6k/tTPD+pDBA8+c="; }
          { name = "org"; hash = "sha256-N/zlpv4oXVfjk+a/7vM0nAPsCCBMVvWN3oavPbPmKwk="; }
          { name = "regex"; hash = "sha256-4NHC4z07lBOhmBABNJqpBYds3P6v1mAY9/i0+MuKeuc="; }
          { name = "ruby"; hash = "sha256-8ooaR58y9jCtQJ2oKIw3ZESG7rzCjrUNeBSdm8SC1jU="; }
          { name = "python"; hash = "sha256-zWcb3Of6dB1PF1OwwrWSJ7z+WvmMnruaum49J5x1+DI="; }
          { name = "rust"; hash = "sha256-E2h5wH4tei4oUt/Bp+26+JQqPauBIv0e9V/8r/CWroM="; }
          { name = "proto"; hash = "sha256-eDnzT35wGxFzhcvy61d+1VG8ObB999mcakG3NNlrcck="; }
          { name = "scala"; hash = "sha256-EhVojG0RKh+44cnHUSKGa97Jw5eeIcSndL+zFnTD7Nk="; }
          { name = "nix"; hash = "sha256-pockUWVZUWcfRZ+p0+TkhLlp1YMppBHYJVy/TnEy+pc="; }
          { name = "vimdoc"; hash = "sha256-6sFzc6DwJrzlRVpKIdhYqx4RtAplpvkAlB51ogDOkbE="; }
          {
            name = "markdown";
            hash = "sha256-JTfUM+RWZOGUvF3gERiK3JKENAzPRKnNfUrSDPZqDyY=";
            srcRoot = "tree-sitter-markdown";
          }
          {
            name = "markdown_inline";
            hash = "sha256-JTfUM+RWZOGUvF3gERiK3JKENAzPRKnNfUrSDPZqDyY=";
            srcRoot = "tree-sitter-markdown-inline";
          }
          {
            name = "mlir";
            hash = "sha256-W95vLOnH54jm23J8zsVbtPj9SzuqORDrw1vzYjGWmp4=";
            needs_generate = true;
          }
          { name = "yaml"; hash = "sha256-tZgjmjT1jR3LfuJYDYysVr3MxTnhLlYRRtePVU643Bw="; }
        ];
      in
      {
        source = "${tsLoader}${tsLoader.scriptPath}";
        target = "nvim/site/plugin/treesitter-parsers.lua";
      };

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
        success_symbol = "[➜](blue)";
        error_symbol = "[➜](bold red)";
      };
      format =
        let
          components = [
            "$hostname"
            "$directory"
            "$nix_shell"
            "$git_branch"
            "$custom"
            "$sudo"
            "$cmd_duration"
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
        format = "\\([$ssh_symbol]($style) [$hostname](bold blue)\\) ";
      };
    };
  };
}
