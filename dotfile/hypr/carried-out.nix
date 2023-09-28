{ writeText, mkWpaperDWrapper, homeDirectory }:
let
  safeWallpapers = writeText "wpaperd-safe.toml" ''
    [default]
    path = '${homeDirectory}/Pictures/Wallpapers/4K'
    duration = "30m"
    apply-shadow = true
  '';
in
writeText "hypr-carry-out.conf" ''
  # Hyprland conf for single monitor, eg: carry out
  monitor=eDP-1,preferred,auto,2
  exec-once = ${mkWpaperDWrapper safeWallpapers}

  # Optimize battery usage
  decoration {
      blur {
          enabled = false
      }
      drop_shadow = false
  }

  animations {
      enabled = false
  }
''
