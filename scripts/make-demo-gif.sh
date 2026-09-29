#!/usr/bin/env bash
# Convert a screen recording (webm/mp4/mkv) into an optimized GIF for the README.
#
# Usage:
#   ./scripts/make-demo-gif.sh <input> [output] [width]
#
#   input   path to recording (e.g. ~/Videos/Screencasts/Screencast.webm)
#   output  defaults to assets/demo.gif
#   width   defaults to 900 (pixels — keeps it README-friendly)

set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 3 ]; then
  sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

in=$1
out=${2:-assets/demo.gif}
w=${3:-900}

# An unquoted glob that matches several recordings shifts the second one into
# [output], where ffmpeg -y would overwrite it. Only ever write a .gif.
case $out in
  *.gif) ;;
  *) echo "output must be a .gif file (got: $out)" >&2; exit 1 ;;
esac
case $w in
  '' | *[!0-9]*) echo "width must be a number of pixels (got: $w)" >&2; exit 1 ;;
esac

mkdir -p "$(dirname "$out")"
palette=$(mktemp --suffix=.png)
trap 'rm -f "$palette"' EXIT

# Pass 1: build a palette tuned to the video's color distribution.
ffmpeg -y -loglevel error -i "$in" \
  -vf "fps=12,scale=$w:-1:flags=lanczos,palettegen=stats_mode=diff" \
  "$palette"

# Pass 2: encode with the palette + dithering.
ffmpeg -y -loglevel error -i "$in" -i "$palette" \
  -lavfi "fps=12,scale=$w:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a" \
  "$out"

echo "wrote $out ($(du -h "$out" | cut -f1))"
