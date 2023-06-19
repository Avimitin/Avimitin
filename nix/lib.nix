{ pkgs }:

with builtins;

rec {
  toSrc = path: { source = ../dotfile/${path}; };
  toMulSrc = pathes:
    listToAttrs (map (p: {
      name = p;
      value = toSrc p;
    }) pathes);

  dlFromGh = { name, owner, repo, rev, sha256 }: {
    inherit name;
    src = pkgs.fetchFromGitHub { inherit owner repo rev sha256; };
  };

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
}
