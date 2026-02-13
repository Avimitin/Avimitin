{ config }:
{
  # Read config from dotfile directory and tranform into home-manager configFile attribute
  fromDotfile = path: {
    target = "${path}";
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/kurisu/dotfile/${path}";
  };
}
