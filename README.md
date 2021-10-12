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
| starship                                            | fancy promt                                |
| zoxide                                              | easy jump                                  |
| nm-applet                                           | network manager                            |
| feh                                                 | background image                           |
| [st](https://github.com/Avimitin/st)                | simple terminal                            |
| [dmenu](https://github.com/Avimitin/dmenu)          | app, script selector                       |
| [ncspot](https://github.com/hrkfdn/ncspot)          | Light weight Spotify player                |

## Font

You will need to install [Jetbrains Mono](https://github.com/ryanoasis/nerd-fonts/releases)

## i3 is deleted

![img](./images/i3-screenshot.png)

I am using [DWM](https://github.com/Avimitin/sdwm) now. The i3 configuration is 
now deleted. If you still wants my i3 configuration, please use git to revert
history to
[`0b8823cc`](https://github.com/Avimitin/dotfile/commit/0b8823cc94ff38f4ad92793e73178470d6796b95).

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

