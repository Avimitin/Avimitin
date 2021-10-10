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

## What Apps I use

| Software                                            | Why                                        |
| ---                                                 | ---                                        |
| tmux                                                | Terminal Pane                              |
| neovim(latest build)                                | Editor                                     |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI                                    |
| exa                                                 | Another ls                                 |
| git-delta                                           | fancy git diff                             |
| [picom](https://github.com/jonaburg/picom)          | Blur, shadow, round corners and animations |
| nnn                                                 | file explorer                              |
| fish                                                | Shell for 90s                              |
| alacritty                                           | Terminal with GPU accelerate               |
| acpi                                                | battery information                        |
| sysstat                                             | CPU information                            |
| starship                                            | fancy promt                                |
| zoxide                                              | easy jump                                  |
| nm-applet                                           | network manager                            |
| feh                                                 | background image                           |
| i3-gap                                              | windows manager                            |
| i3-block                                            | i3 bar                                     |
| [st](https://github.com/Avimitin/st)                | simple terminal                            |
| [dmenu](https://github.com/Avimitin/dmenu)          | app, script selector                       |
| [ncspot](https://github.com/hrkfdn/ncspot)          | Light weight Spotify player                |

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

### Deprecated warning

But anyway, I am using [DWM](https://github.com/Avimitin/sdwm) now. Please take
a look at it. I think you will love it. The i3 configuration is now archive.

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
picom -b -c
```

### Git

I've written a git commit message template which follow the Angular commit
guide line and a blog from [chris beams](https://chris.beams.io/posts/git-commit/).
Checkout .gittemplate file for details.

Use the below command to apply the template.

```bash
git config --global commit.template ~/.config/.gittemplate
```

#### Credit

The contents in my git commit template is inspired by below project.

- https://chris.beams.io/posts/git-commit
- https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit
- https://github.com/torvalds/linux/commits/master

