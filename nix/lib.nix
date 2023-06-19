{ pkgs }:

with builtins;

rec {
  # A helper function to convert a list of element into a set.
  # For example:
  #
  # > with builtins;
  # > listToAttrsMap { nameFn = (x: toString x); valFn = (x: x); } [ 1 2 3 ]
  #
  # will produce:
  #
  # { "1" = 1; "2" = 2; "3" = 3 }
  #
  listToAttrsMap = { nameFn, valFn, }: list:
    listToAttrs (map (elem: {
      name = (nameFn elem);
      value = (valFn elem);
    }) list);

  toSrc = path: { source = ../dotfile/${path}; };

  toMulSrc = listToAttrsMap {
    nameFn = (path: path);
    valFn = (path: toSrc path);
  };

  dlFromGh = { name, owner, repo, rev, sha256 }: {
    inherit name;
    src = pkgs.fetchFromGitHub { inherit owner repo rev sha256; };
  };

  # This function is copied and modified from home-manager/modules/programs/fish.nix
  genFishPlugs = listToAttrsMap {
    nameFn = (plugin: "fish/conf.d/plugin-${plugin.name}.fish");
    valFn = (plugin: {
      source = pkgs.writeTextFile {
        name = "${plugin.name}.fish";
        text = ''
          # Plugin ${plugin.name}
          set -l plugin_dir ${plugin.src}

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
    });
  };
}
