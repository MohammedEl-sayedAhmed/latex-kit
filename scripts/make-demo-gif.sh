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

if [ $# -lt 1 ]; then
  sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

in=$1
out=${2:-assets/demo.gif}
w=${3:-900}

mkdir -p "$(dirname "$out")"
palette=$(mktemp --suffix=.png)

# Pass 1: build a palette tuned to the video's color distribution.
ffmpeg -y -loglevel error -i "$in" \
  -vf "fps=12,scale=$w:-1:flags=lanczos,palettegen=stats_mode=diff" \
  "$palette"

# Pass 2: encode with the palette + dithering.
ffmpeg -y -loglevel error -i "$in" -i "$palette" \
  -lavfi "fps=12,scale=$w:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a" \
  "$out"

rm -f "$palette"
echo "wrote $out ($(du -h "$out" | cut -f1))"
