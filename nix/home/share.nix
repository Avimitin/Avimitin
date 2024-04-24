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
          { name = "bash"; hash = "sha256-mKKBL8dQM/RepoTswvQDyHna6AHZBFIybizAsNfsXYc="; }
          { name = "beancount"; hash = "sha256-4KQUwv3PDJPBChLhDSXJpKNUrzUPOk1o9Bs6Z2Tq8+Q="; }
          { name = "c"; hash = "sha256-PMyML+nO9q8G2vpmRKmr0xbBqvO1LW+jIMtrFBaZZ9g="; }
          { name = "cpp"; hash = "sha256-UZNedNPFpzHwrAnbSaaDP9ATyoA5+SMYHuRsgA5m+xM="; }
          { name = "css"; hash = "sha256-wu+mjyBNvIgZAEL36CqXQntbGq9qizQUzhzb86bKSU8="; }
          { name = "diff"; hash = "sha256-0DMJCM0ps+oDyz4IzOPuI92lzDQMaq4trGos16WJQBc="; }
          { name = "firrtl"; hash = "sha256-X//iBrCi4sYgqNubUrnXCRoKBOUMsgS4u9yht7ioucA="; }
          { name = "gitcommit"; hash = "sha256-j+W3wmSKTEXAB/LyOnBvzNx4CptQ+JplJ3IVQzs86ss="; }
          { name = "haskell"; hash = "sha256-BTGCx4ZtEBRunCUGufoiPBZ6U0AhGpT56mOQ37UwvoA="; }
          { name = "javascript"; hash = "sha256-Pw0mWgVMw7dSYwJ72aTLfSmZZ/j4HwN4gYJoiJyHiAs="; }
          { name = "typescript"; hash = "sha256-9pvCu2u1+9zCtupDaDZKnIr5ZW58EtKs4VOX6OuRCqA="; srcRoot = "typescript"; }
          { name = "tsx"; hash = "sha256-9pvCu2u1+9zCtupDaDZKnIr5ZW58EtKs4VOX6OuRCqA="; srcRoot = "tsx"; }
          { name = "typst"; hash = "sha256-t7lDb8mbtkwTbhEouof2kGRRYBcFKSzbf1U/v/C38no="; }
          { name = "llvm"; hash = "sha256-c63jN6pyIssjthp+3f5pYWMwUq+usjhlP2lF/zVNdc8="; }
          { name = "lua"; hash = "sha256-jGCiNmY35QYqWga5xOSvds0Vo9Kw6k/tTPD+pDBA8+c="; }
          { name = "org"; hash = "sha256-N/zlpv4oXVfjk+a/7vM0nAPsCCBMVvWN3oavPbPmKwk="; }
          { name = "regex"; hash = "sha256-4NHC4z07lBOhmBABNJqpBYds3P6v1mAY9/i0+MuKeuc="; }
          { name = "ruby"; hash = "sha256-8ooaR58y9jCtQJ2oKIw3ZESG7rzCjrUNeBSdm8SC1jU="; }
          { name = "python"; hash = "sha256-zWcb3Of6dB1PF1OwwrWSJ7z+WvmMnruaum49J5x1+DI="; }
          { name = "rust"; hash = "sha256-YZkYi0s1QNc9y1xJcCdNWTQEiuRdUARBjSesiHLJJZM="; }
          { name = "proto"; hash = "sha256-eDnzT35wGxFzhcvy61d+1VG8ObB999mcakG3NNlrcck="; }
          { name = "scala"; hash = "sha256-rEkVB5P8G6dafx16MS070KI8BFUVhXz9b1FjSgA8vPI="; }
          { name = "nix"; hash = "sha256-pockUWVZUWcfRZ+p0+TkhLlp1YMppBHYJVy/TnEy+pc="; }
          { name = "vimdoc"; hash = "sha256-wauZR0d16dMpSSUkQ5daIKHuYrq0nGR3r58ukI002fU="; }
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
            hash = "sha256-axlG6LZvv2kVmGXb8XTlWoh7CzbwdU2iK4hcxQNKuFU=";
            needs_generate = true;
          }
          { name = "yaml"; hash = "sha256-MgW4/v3yhdTQY6u3V4zxvwWUbC0oT4JR8czc6bMqHCA="; }
        ];
      in
      {
        source = "${tsLoader}${tsLoader.scriptPath}";
        target = "nvim/site/plugin/treesitter-parsers.lua";
      };

    tmux-thumbs =
      let
        thumbs = pkgs.rustPlatform.buildRustPackage {
          pname = "tmux-thumbs";
          version = "v0.8.0-ae91d5f";
          src = pkgs.fetchFromGitHub {
            owner = "Avimitin";
            repo = "tmux-thumbs";
            rev = "f690cde956c9d6b7837c5fd121b2a859b72fa7c7";
            hash = "sha256-v6Rql+XjeCTq9rAHGRN3eaXWYnavzAXUrghK4j5tZx8=";
          };

          cargoHash = "sha256-ALNhEjjICxxose7VROEt+ABt3R+EXjHm2bJjy3DPXKE=";

          postInstall = ''
            mkdir -p $out/lib

            tee -a $out/lib/tmux-thumbs-wrapper.sh << EOF
            #!/bin/bash
            ${placeholder "out"}/bin/tmux-thumbs --thumbs-path ${placeholder "out"}/bin/thumbs || true
            EOF

            tee -a $out/lib/tmux-thumbs.tmux <<EOF
            #!/bin/bash
            tmux set-option -ag command-alias "thumbs-pick=run-shell -b ${placeholder "out"}/lib/tmux-thumbs-wrapper.sh"
            tmux bind-key "space" thumbs-pick
            EOF

            chmod +x $out/lib/tmux-thumbs*
          '';
        };
      in
      {
        source = "${thumbs}/lib/tmux-thumbs.tmux";
        target = "tmux/plugins/tmux-thumbs/tmux-thumbs.tmux";
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
        format = "[$ssh_symbol]($style) [$hostname](bold blue) ";
      };
    };
  };
}
