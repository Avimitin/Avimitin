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

    # Development
    nixpkgs-fmt # global formatter for all nix sources
    nil # Nix language server
    pyright # Python language server
    black # Python formatter
    haskellPackages.fourmolu # Haskell formatter
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

  xdg.dataFile =
    let
      tsLoader = pkgs.generate-nvim-treesitter-parsers [
        { name = "bash"; hash = "sha256-b1r/T+Y4Kmui/pHsncozP8OO6rMMHJj+Xaa2Qzwo/cI="; }
        { name = "c"; hash = "sha256-sB8fNfusjC9yTlrizb2mufDzQPvBajTJC+ewF9awBqA="; }
        { name = "cpp"; hash = "sha256-27QjVy8quWyGhFCv/6GATG1xjGnkB9LTcvlPMuR3NB0="; }
        { name = "css"; hash = "sha256-vBm3z2x2m4pDPWzLIezkgqaKPGyTx4zQagJvDU6jVbY="; }
        { name = "diff"; hash = "sha256-0DMJCM0ps+oDyz4IzOPuI92lzDQMaq4trGos16WJQBc="; }
        { name = "firrtl"; hash = "sha256-X//iBrCi4sYgqNubUrnXCRoKBOUMsgS4u9yht7ioucA="; }
        { name = "gitcommit"; hash = "sha256-f7tSOL6/s+FAt3siH+eO63jXzbU79yh78QfHHvmBFbE="; }
        { name = "haskell"; hash = "sha256-emH6ZM/PndCQ3Co5KqC0B4i6m6UHikZB7SoZ4XpUnIs="; }
        { name = "javascript"; hash = "sha256-mQQHsSRwyQuXBLtPBj2kgwdtdlK8qFtEcIqG/2ogiY0="; }
        { name = "typescript"; hash = "sha256-xpXdkmodfLEljrqF/fZt/a6LFdfevi+FzzM5rixfB1E="; srcRoot = "typescript"; }
        { name = "tsx"; hash = "sha256-xpXdkmodfLEljrqF/fZt/a6LFdfevi+FzzM5rixfB1E="; srcRoot = "tsx"; }
        { name = "llvm"; hash = "sha256-c63jN6pyIssjthp+3f5pYWMwUq+usjhlP2lF/zVNdc8="; }
        { name = "lua"; hash = "sha256-ZocgN+GD7FOv/a2QuX8EoxwJ3MZCBnT2Y6Kv4jOvYy0="; }
        { name = "org"; hash = "sha256-N/zlpv4oXVfjk+a/7vM0nAPsCCBMVvWN3oavPbPmKwk="; }
        { name = "regex"; hash = "sha256-Y6A1YqbjItM4V5lQ7IM8EMa+nm6v+p/DHYSEVnF29ac="; }
        { name = "ruby"; hash = "sha256-RaxVKNoIaDj6tMi63ERmeRmq5yHlWL9/u2v6XpMsK/g="; }
        { name = "python"; hash = "sha256-2BW17L46CYrGISeSLWF8RrpAA0enEdJjlvuljnKDgLY="; }
        { name = "rust"; hash = "sha256-rwZbCa5f96BiqYWdbiHBRnlEU0TBJyycCoru0hxxu+U="; }
        { name = "scala"; hash = "sha256-2zmNRTey8cFrK9Kx4PrJnhMXFwX7HZj32GGeplJuiDc="; }
        { name = "nix"; hash = "sha256-rzrxcqcc7V+6pgdZ8Q/3VJd5/Oa58AtKKfoC3MBcirs="; }
        {
          name = "markdown";
          hash = "sha256-52QZ4bjJIvGxE4N4OJohdcyGSKjxep0pINJjgVq4H+M=";
          srcRoot = "tree-sitter-markdown";
        }
        {
          name = "markdown_inline";
          hash = "sha256-52QZ4bjJIvGxE4N4OJohdcyGSKjxep0pINJjgVq4H+M=";
          srcRoot = "tree-sitter-markdown-inline";
        }
        {
          name = "mlir";
          hash = "sha256-gSvZBwAvR93jfvcBLMBlKVQ/XOe9NXoh/Jzm8HRMcBI=";
          needs_generate = true;
        }
        {
          name = "ocaml";
          hash = "sha256-ovTvflpzfMvI+NaKtLfMyI/SyxPODqr4mRkfzROIEjc=";
          srcRoot = "ocaml";
        }
        {
          name = "ocaml_interface";
          hash = "sha256-ovTvflpzfMvI+NaKtLfMyI/SyxPODqr4mRkfzROIEjc=";
          srcRoot = "interface";
        }
        { name = "yaml"; hash = "sha256-RrYFKrhqFLsjQG+7XFbcQ2eYy2eyig5/r+MYO8DId4g="; }
      ];
    in
    {
      # We can't install this file to .config/nvim because the whole nvim directory is a symlink to nix store
      nvim-treesitter-parsers = {
        source = "${tsLoader}${tsLoader.passthru.luaPath}";
        target = "nvim/site/plugin/treesitter-parsers.lua";
      };
      nvim-treesitter-updater = {
        source = "${tsLoader.passthru.updateScript}/bin/treesitter-hash-batch-updater";
        target = "nvim/assets/treesitter-updater.bash";
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
