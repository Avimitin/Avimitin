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
    haskellPackages.fourmolu # Haskell formatter
    nodePackages.typescript-language-server # For frontend development
    prettierd # js/ts formatter
    metals # Scala LSP
    clang-tools # Contains clangd
    lua-language-server # Lua LSP
    stylua # Lua formatter
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

  xdg.dataFile =
    let
      tsLoader = pkgs.generate-nvim-treesitter-parsers [
        { name = "bash"; hash = "sha256-LXKyqGeKg3OJHZ5666m8xnMHdqcdybZ3BRXKA3Fyh6o="; }
        { name = "c"; hash = "sha256-BmDb4PVpEafmRmmF0pPrvXQypn7FOt3hAulD0R59FWY="; }
        { name = "cpp"; hash = "sha256-C95+PpAwRmp4GGHHko96qXoJl4y+pLPhhAa1vyIDt0A="; }
        { name = "css"; hash = "sha256-wu+mjyBNvIgZAEL36CqXQntbGq9qizQUzhzb86bKSU8="; }
        { name = "diff"; hash = "sha256-0DMJCM0ps+oDyz4IzOPuI92lzDQMaq4trGos16WJQBc="; }
        { name = "firrtl"; hash = "sha256-X//iBrCi4sYgqNubUrnXCRoKBOUMsgS4u9yht7ioucA="; }
        { name = "gitcommit"; hash = "sha256-rqNwsqyEHchldNbs8kUF4zDr1pB8qrSMYDlAvQrysFs="; }
        { name = "haskell"; hash = "sha256-7rbLamrUFPgRtANZMNxF99bC/n3Vy5Bl+rOIcInsN8o="; }
        { name = "javascript"; hash = "sha256-N8BRupggd6BWFXyTTP7mL56Iuy40GsQHqs/b6Pd9Qpk="; }
        { name = "typescript"; hash = "sha256-KqA7S908lydGdXJKMvhaHptCTky7fhztL+wTFe53PBA="; srcRoot = "typescript"; }
        { name = "tsx"; hash = "sha256-KqA7S908lydGdXJKMvhaHptCTky7fhztL+wTFe53PBA="; srcRoot = "tsx"; }
        { name = "llvm"; hash = "sha256-c63jN6pyIssjthp+3f5pYWMwUq+usjhlP2lF/zVNdc8="; }
        { name = "lua"; hash = "sha256-ZocgN+GD7FOv/a2QuX8EoxwJ3MZCBnT2Y6Kv4jOvYy0="; }
        { name = "org"; hash = "sha256-N/zlpv4oXVfjk+a/7vM0nAPsCCBMVvWN3oavPbPmKwk="; }
        { name = "regex"; hash = "sha256-4NHC4z07lBOhmBABNJqpBYds3P6v1mAY9/i0+MuKeuc="; }
        { name = "ruby"; hash = "sha256-1BLQUVzL1aa09B5+moDBZPywidOUlc7LCj+dnvTF0BU="; }
        { name = "python"; hash = "sha256-Dc+H+6UT7uyxglRgIFMQwfVjmgBUCFOtlw5hWg6rVRw="; }
        { name = "rust"; hash = "sha256-Kp2419Fg1wVo/7paaZgST5NSjiuZphzvTim2sF55nA4="; }
        { name = "proto"; hash = "sha256-eDnzT35wGxFzhcvy61d+1VG8ObB999mcakG3NNlrcck="; }
        { name = "scala"; hash = "sha256-YtqWs2koZbYs0EGm4/Sk2WeON/NManu5OBmVihTU0to="; }
        { name = "nix"; hash = "sha256-U83d361iH3HTqh4ZMWovYE+WOwPLKOi28/aFiG3Olkg="; }
        { name = "vimdoc"; hash = "sha256-KbZwevfj0OahCrsUcOvJ1ArD41Q1DOao4tSq2ukgQNo="; }
        {
          name = "markdown";
          hash = "sha256-ohsWstf+12c9DtRUZPQDa1PsihFSw4x/7t3zcSU60YA=";
          srcRoot = "tree-sitter-markdown";
        }
        {
          name = "markdown_inline";
          hash = "sha256-ohsWstf+12c9DtRUZPQDa1PsihFSw4x/7t3zcSU60YA=";
          srcRoot = "tree-sitter-markdown-inline";
        }
        {
          name = "mlir";
          hash = "sha256-gSvZBwAvR93jfvcBLMBlKVQ/XOe9NXoh/Jzm8HRMcBI=";
          needs_generate = true;
        }
        {
          name = "ocaml";
          hash = "sha256-3ZH/70tytbV5k4uCpJOjigDdsrkzCtlT3mO7ik+vzss=";
          srcRoot = "ocaml";
        }
        {
          name = "ocaml_interface";
          hash = "sha256-3ZH/70tytbV5k4uCpJOjigDdsrkzCtlT3mO7ik+vzss=";
          srcRoot = "interface";
        }
        { name = "yaml"; hash = "sha256-RrYFKrhqFLsjQG+7XFbcQ2eYy2eyig5/r+MYO8DId4g="; }
      ];
    in
    {
      # We can't install this file to .config/nvim because the whole nvim directory is a symlink to nix store
      nvim-treesitter-parsers = {
        source = "${tsLoader}${tsLoader.scriptPath}";
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
        success_symbol = "[➜](blue)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[☉](green)";
        vimcmd_replace_one_symbol = "[⟁](purple)";
        vimcmd_replace_symbol = "[⟁](bold purple)";
        vimcmd_visual_symbol = "[⚆](green)";
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
        format = "[$ssh_symbol]($style) ";
      };
    };
  };
}
