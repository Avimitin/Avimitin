# MY DOTFILE

```text
 ____  ____  _____  _____ _  _     _____
/  _ \/  _ \/__ __\/    // \/ \   /  __/
| | \|| / \|  / \  |  __\| || |   |  \  
| |_/|| \_/|  | |  | |   | || |_/\|  /_ 
\____/\____/  \_/  \_/   \_/\____/\____\  by Avimitin
```

![screen shot](./images/screenshot.png)

Try it: `git clone https://github.com/Avimitin/dotfile.git ~/.config`

## Dependency

| Software             | Why                          |
| ---                  | ---                          |
| tmux                 | Terminal Pane                |
| neovim(latest build) | Editor                       |
| lazygit              | Git TUI                      |
| exa                  | Another ls                   |
| git-delta            | fancy git diff               |
| picom                | Gaussain blur                |
| nnn                  | file explorer                |
| fish                 | Shell for 90s                |
| alacritty            | Terminal with GPU accelerate |
| acpi                 | battery information          |
| sysstat              | CPU information              |
| starship             | fancy promt                  |
| zoxide               | easy jump                    |
| nm-applet            | network manager              |
| feh                  | background image             |

## Font

You will need to install [Jetbrains Mono](https://github.com/ryanoasis/nerd-fonts/releases)

## i3 keymap

Normally mod key is the win key. And `hjkl` can be replaced with `↑ ↓ ← →`

| keymap                       | functionality        |
| ---                          | ---                  |
| `<Mod> + h/j/k/l`            | focused around       |
| `<Mod> + Shift + h/j/k/l`    | moved windows around |
| `<Mod> + 1234567890`         | focuse workspace     |
| `<Mod> + Shift + 1234567890` | focuse workspace     |
| `<Mod> + Enter`              | open terminal        |
| `<Mod> + o`                  | open app selector    |

For detail please take a look on [i3](./i3/config)

### Resize mod

Press `<Mod> + r` to get into resize mod.

| keymap    | functionality  |
| ---       | ---            |
| `- / +`   | resize gap     |
| `↑ ↓ ← →` | resize windows |

## Environment setting

### fcitx

```bash
# running fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
```

### picom

```
# picom
picom --experimental-backends --backend glx -b -c
```

