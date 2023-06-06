#!/bin/sh

set -e

dunstify "Changing bg"

N=$(( $RANDOM%1000 ))

## NSFW
PIC_URL=( \
$(curl -sSL "https://konachan.com/post.json?page=${N}&tags=width%3A2560..+height%3A1600..+rating%3Asafe" \
  | jq --raw-output ".[$(( $RANDOM%20 ))].file_url, .[$(( $RANDOM%20 ))].file_url") )

## SFW
# PAGE=$(( $RANDOM%50 ))
# SEED=$(( $RANDOM%99999 ))
# PIC_URL=$(curl -sSL --connect-timeout 15 \
#   "https://wallhaven.cc/api/v1/search?sorting=toplist&resolutions=3840x2160&page=${PAGE}&purity=110&topRange=3M&seed=${SEED}" \
#   | jq --raw-output ".data[$N].path")
##
dunstify "Image fetch successfully"

OUTPUT_DIR="$HOME/Pictures/tmp_backgrounds"
mkdir -p $OUTPUT_DIR

# clean up directory
find $OUTPUT_DIR -type f -exec rm {} \;

LOG_DIR="/tmp/rand-anime-background-wget.log"
if [ -e $LOG_DIR ]; then
  printf "Cleaning log..."
  rm $LOG_DIR
  printf "Success\n"
fi

download ()
{
  url=$1
  filename=$(basename $url)
  ext=${filename##*.}
  output="$OUTPUT_DIR/tmp_$RANDOM.$ext"
  echo "Downloading $filename"

  if ! wget -vv -c "$url" -O $output > $LOG_DIR 2>&1; then
    dunstify "fail to download $i, log store in $LOG_DIR"
    return 1
  fi

  sums=$(sha1sum -b $output | cut -d' ' -f1 | xargs)

  mv $output "$OUTPUT_DIR/$sums.$ext"

  return 0
}

export -f download
export OUTPUT_DIR
export LOG_DIR

echo ${PIC_URL[@]} | xargs -n 1 -P 2 bash -c 'download "$@"' --
if [ "$?" -ne "0" ]; then
  exit 1
fi

dunstify "Image download successfully"

feh --bg-fill --recursive $OUTPUT_DIR
