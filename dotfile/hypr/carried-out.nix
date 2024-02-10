{ writeText }:
writeText "hypr-carry-out.conf" ''
  # Hyprland conf for single monitor, eg: carry out
  monitor=eDP-1,preferred,auto,1
  env = GDK_SCALE,1
  env = QT_AUTO_SCREEN_SCALE_FACTOR,1

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
