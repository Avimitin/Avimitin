#!/usr/bin/env bash

addWants() {
  service="$1"; shift
  systemctl --user add-wants niri.service "$service"
}

services=(
  "foot-server.service"
  "gamemoded.service"
  "kde-indicator.service"
  "plasma-polkit-agent.service"
  "swaybg@wallpaper.service"
  "swaybg@backdrop.service"
  "swaync.service"
  "vicinae-server.service"
  "waybar.service"
)

for s in "${services[@]}"; do
  addWants "$s"
done

systemctl --user daemon-reload
