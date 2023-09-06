{ pkgs }:
{

  # Read config from dotfile directory and tranform into home-manager configFile attribute
  fromDotfile = path: {
    target = "${path}";
    source = ../dotfile/${path};
  };

  # Fetch fish plugin from GitHub and transform it into home-manager configFile attribute
  fetchFishPlugin = spec: {
    target = "fish/conf.d/plugin-${spec.repo}.fish";
    source = let src = pkgs.fetchFromGitHub spec; in
      pkgs.writeTextFile {
        name = "${spec.repo}.fish";
        text = ''
          set -l plugin_dir ${src}

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

  # Fetch tmux plugin from GitHub and put all of them into $XDG_DATA_HOME/tmux/plugins
  fetchTmuxPlugin = spec: {
    target = "tmux/plugins/${spec.repo}";
    source = pkgs.fetchFromGitHub spec;
  };

  # Substitute the pass in `file` with given `kvs` key-value pair.
  #
  # Usage:
  #
  # ```nix
  # newFile = substituted ./path.conf { "FOO" = "bar"; }
  # ```
  #
  substituted = with builtins;
    kvs: filepath:
      let
        genSubst = k: v: "--subst-var-by ${k} ${if v == null then ''" "'' else v}";
        substituteArgs = pkgs.lib.mapAttrsToList genSubst kvs;
        substituteArgString = concatStringsSep " " substituteArgs;
        name = pkgs.lib.escapeShellArg (baseNameOf filepath);
      in
      pkgs.runCommand name { } ''
        substitute ${filepath} \
          $out \
          ${substituteArgString}
      '';
}
