{ writeText }:
writeText "hypr-office.conf" ''
  monitor=DP-1,preferred,auto,2
  env = GDK_SCALE,2
  env = QT_AUTO_SCREEN_SCALE_FACTOR,2
''
