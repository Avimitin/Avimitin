{ config, pkgs, ... }:

with builtins;

let
  toSrc = path: { source = ../dotfile/${path}; };
  toMulSrc = pathes:
    listToAttrs (map (p: {
      name = p;
      value = toSrc p;
    }) pathes);

  # This function is copied and modified from home-manager/modules/programs/fish.nix
  genFishPlugs = plugins:
    listToAttrs (map (plug: {
      name = "fish/conf.d/plugin-${plug.name}.fish";
      value = {
        source = pkgs.writeTextFile {
          name = "${plug.name}.fish";
          text = ''
            # Plugin ${plug.name}
            set -l plugin_dir ${plug.src}

            # Set paths to import plugin components
            if test -d $plugin_dir/functions
              set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
            end

            if test -d $plugin_dir/completions
              set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
            end

            # Source initialization code if it exists.
            if test -d $plugin_dir/conf.d
              for f in $plugin_dir/conf.d/*.fish
                source $f
              end
            end

            if test -f $plugin_dir/key_bindings.fish
              source $plugin_dir/key_bindings.fish
            end

            if test -f $plugin_dir/init.fish
              source $plugin_dir/init.fish
            end
          '';
        };
      };
    }) plugins);

  fishPlugins = [
    {
      name = "fzf";
      src = pkgs.fetchFromGitHub {
        owner = "PatrickF1";
        repo = "fzf.fish";
        rev = "c5e170730b4f8395e116d7c06883ed53da2d5561";
        sha256 = "sha256-xWaMd5POCDeeFTsGtHbIvsPelIp+GZPC1X1CseCo3BA=";
      };
    }

    {
      name = "autopair";
      src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "autopair.fish";
        rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
        sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
      };
    }

    {
      name = "prompt";
      src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "hydro";
        rev = "41b46a05c84a15fe391b9d43ecb71c7a243b5703";
        sha256 = "sha256-zmEa/GJ9jtjzeyJUWVNSz/wYrU2FtqhcHdgxzi6ANHg=";
      };
    }
  ];
in {
  home = {
    username = "i";
    homeDirectory = "/home/i";
    stateVersion = "23.05";
    file = {
      ".bashrc" = toSrc "bash/.bashrc";
      ".gitconfig" = toSrc "git/.gitconfig";
      ".tmux.conf" = toSrc "tmux/.tmux.conf";
    };
  };
  # Symlink file only to avoid program write some unexpected stuff into directory.
  xdg.configFile = (toMulSrc [
    "broot/conf.hjson"
    "fish/config.fish"
    "lazygit/config.yml"
    "nix/nix.conf"
    "paru/paru.conf"
    "systemd/user"
    "nvim"
  ]) // (genFishPlugs fishPlugins) // {
    # I really hate nixpkgs, for now.
    # So I don't want to add $HOME/.nix-profile/bin into $PATH, as it will pollute my environment.
    # The below fish script will create an alias `hm` to help me execute the home-manager.
    # Also, it force the home-manager to use this nix file to avoid any other possible problem.
    "fish/conf.d/home-manager.fish".source = pkgs.writeTextFile {
      name = "home-manager.fish";
      text = ''
        alias hm "${config.home.path}/bin/home-manager -f ${
          toString ./homelab.nix
        }"'';
    };
  };

  programs.home-manager.enable = true;
}
