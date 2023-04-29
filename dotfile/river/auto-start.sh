#!/bin/sh

# Enable river session
systemctl --user import-environment
systemctl --user start river-session.target

# Enable background daemon
systemctl --user start kanshi
systemctl --user start swaybg
systemctl --user start fcitx5
