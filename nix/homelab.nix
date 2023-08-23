{ config, pkgs, ... }:

with (import ./lib.nix { inherit pkgs; });

let

  fishPlugins = [
    (dlFromGh {
      name = "fzf";
      owner = "PatrickF1";
      repo = "fzf.fish";
      rev = "c5e170730b4f8395e116d7c06883ed53da2d5561";
      sha256 = "sha256-xWaMd5POCDeeFTsGtHbIvsPelIp+GZPC1X1CseCo3BA=";
    })

    (dlFromGh {
      name = "autopair";
      owner = "jorgebucaran";
      repo = "autopair.fish";
      rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
      sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
    })

    (dlFromGh {
      name = "prompt";
      owner = "jorgebucaran";
      repo = "hydro";
      rev = "41b46a05c84a15fe391b9d43ecb71c7a243b5703";
      sha256 = "sha256-zmEa/GJ9jtjzeyJUWVNSz/wYrU2FtqhcHdgxzi6ANHg=";
    })
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
    "direnv/direnvrc"
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

  programs.home-manager.enable = false;
}
