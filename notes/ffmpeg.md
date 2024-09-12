---
id: ffmpeg
aliases:
  - ffmpeg
tags: []
---

# ffmpeg

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

* Image to MP4

```bash
ffmpeg -i jpg.jpg -r 1/2 -c:v libx264 -pix_fmt yuv420p out.mp4
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

- Tweak volume

```bash
ffmpeg -i cut.mp4 -af "volume=-5.8dB" optimise.mp4
```

* Embed cover into flac

```bash
ffmpeg -i "$flac" -i "$cover" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" -disposition:v attached_pic "$output"
```
