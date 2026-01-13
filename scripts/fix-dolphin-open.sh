#!/usr/bin/env bash

export XDG_MENU_PREFIX=arch-
kbuildsycoca6 --noincremental
exec dolphin "$@"
