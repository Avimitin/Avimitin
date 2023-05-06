<!-- vim:set fo+=t tw=80: -->

- Habits

tag: habbit

Habits:

1. Cue
2. Craving
3. Response
4. Reward

E.g: You feel tired and want to have something to eat.
So you are craving snacks.
You walk through the living room and get some cookie from the fridge.
And you are rewarded with some sweet and nice tasting cookie.

......

A habit will be broke when some part missing.
Like if you ate too much during the lunch so there is no cue for food.
Like if you respond differently by taking a walk or drink some water.

Conclusion:

Rather than trying to resist the temptation, you should never have cue to something.

Turn off the phone.
Close all the useless screen.
Better manage life without exposing yourself to temptation.

- How to sign others keys

tag: gpg sign keys luks encrypt decrypt

```bash
# find the usb driver
sudo fdisk -l

# decrypt the luks device
sudo cryptsetup luksOpen /dev/sdc1 secret # secret is customizable, it is just device name

# mount the usb driver
sudo mount /dev/mapper/secret /mnt/gpgDevice

# set gpg home
set -x GNUPGHOME /mnt/gpgDevice

# receive the gpg key
set otherspubkey "aaabbbcccdddeeefffggg"
gpg --recv-keys $otherspubkey

# sign
gpg --sign-key --ask-cert-level $otherspubkey

# send it back to keyserver
gpg --send-key $otherspubkey

# send it to other keyserver
gpg --keyserver keys.openpgp.org --send-key $otherspubkey

# clean the database
gpg --delete-key $otherspubkey

# unmount the usb driver
sudo umount /mnt/gpgDevice

# encrypt the usb driver
sudo cryptsetup luksClose secret
```

- remove all the `<none>` tag images

tag: docker images

```bash
docker image prune --filter "dangling=true"
```

- os.utime

tag: python os utime

OS module in Python provides functions for interacting with the operating system.
OS comes under Python’s standard utility modules. This module provides a portable
way of using operating system dependent functionality.

os.utime() method of os module in Python is used to set the access and modified
time of the specified path.

```text
Syntax: os.utime(path, times = None, *, [ns, ]dir_fd = None, follow_symlinks = True)

Parameter:
path: A string or bytes object representing a valid file system path.
times (optional): A 2-tuple of the form (atime, mtime) where each member is an
integer or float value representing access time and modification time in seconds
respectively.

ns (optional): A 2-tuple of the form (atime_ns, mtime_ns) where each member is
an integer or float value representing access time and modification time in
nanoseconds respectively.

dir_fd: A file descriptor referring to a directory. The default value of this
parameter is None.

follow_symlinks: A boolean value either True or False. If True method will follow
symbolic link otherwise not.

Return Type: This method does not return any value
```

- rbtree

tag: algorithm alg red black tree rbtree linux kernel

<https://elixir.bootlin.com/linux/latest/source/lib/rbtree.c>

- A4 word memorization method

tag: A4, English, word, memorize

link: https://t.me/NewlearnerGroup/1471725

1. 筛选阅读器内汇总的生词表，过于生僻陈旧的扔掉；
2. 拿一张白纸，把生词逐个抄写上去，不用写中文意思；
3. 每抄一个就把前面已经抄下来的全部单词都读一遍发音、念五遍意思；
4. 反复上一步，直到厌烦；
5. 第二天继续。

- Why you always feel tired

<!-- tag: sleep -->

1. Caffeine left over 12 hours, not drink Caffeine over launch.
2. Improve sleeping.

- ffmpeg operation

<!-- tag: ffmpeg crop mp4 gif -->

* Speed up video

```bash
# Speed up 2 time
ffmpeg -i input.mp4 -filter:v "setpts=0.5*PTS" output.mp4
```

* Drop audio from video

```bash
ffmpeg -i input.mp4 -c copy -an output.mp4
```

* Crop video

```bash
ffmpeg -i input.mp4 -filter:v "crop=$width:$height:$x:$y" output.mp4
```

* Speed Up audio

```bash
# increase 5 time, atempo at most 2.0, but can be repeat
ffmpeg -i input.mp4 -filter:a "atempo=2.0,atempo=2.0,atempo=1.0" output.mp4
```

* Mp4 to GIF

```bash
ffmpeg -i input.mp4 -vf "fps=10,scale=720:-1:flags=lanczos,palettegen" -y "/tmp/palette.png"
ffmpeg -i input.mp4 -i /tmp/palette.png \
   -lavfi "fps=10,scale=720:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y output.gif
```

* Embed ass file

```bash
ffmpeg -i input.mp4 -vf "ass=btmc.ass" out.mp4
```

* Cut video

```bash
# from 00:10 to 20:30
ffmpeg -i input.mp4 -ss 00:10 -to 20:30 out.mp4
```

- PostgreSQL

* PostgreSQL 创建表时，最后一个 column 不能加上逗号。（像函数参数那样理解）

* Copy 
