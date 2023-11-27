{ writeText }:
writeText "hypr-office.conf" ''
  # Hyprland conf for dual monitor

  monitor=eDP-1,disable

  # Position is scaled by 1.5, so to connect two 4K monitor, I need to divide 3840 with 1.5
  monitor=DP-5,preferred,0x0,1.5
  monitor=HDMI-A-1,preferred,2560x0,1.5

  workspace=1,monitor:DP-5
  workspace=2,monitor:HDMI-A-1
''
