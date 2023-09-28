{ writeText, mkWpaperDWrapper, homeDirectory }:
let
  wpaperdConf = writeText "wpaperd-anime.toml" ''
    [default]
    path = '${homeDirectory}/Pictures/Anime'
    duration = "30m"
    apply-shadow = true
  '';
in
writeText "hypr-office.conf" ''
  # Hyprland conf for dual monitor

  monitor=eDP-1,disable

  # Position is scaled by 2, so to connect two 4K monitor, I need to divide 3840 with 2
  monitor=DP-5,preferred,0x0,2
  monitor=HDMI-A-1,preferred,1920x0,2

  workspace=1,monitor:DP-5
  workspace=2,monitor:HDMI-A-1

  exec-once = ${mkWpaperDWrapper wpaperdConf}
''
