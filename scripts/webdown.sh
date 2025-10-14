#!/usr/bin/env bash
set -euo pipefail

ROOT_URL="https://cs50.harvard.edu/x"
OUTDIR="$HOME/mirrors/cs50x"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "1) Checking robots.txt (be polite)"
echo "robots.txt for host:"
curl -sSf "https://cs50.harvard.edu/robots.txt" || echo "(no robots.txt or couldn't fetch)"

echo "2) Running wget mirror (conservative)..."
wget --mirror \
  --page-requisites \
  --adjust-extension \
  --convert-links \
  --no-parent \
  --wait=1 --random-wait \
  --limit-rate=200k \
  --directory-prefix="$OUTDIR" \
  "$ROOT_URL"

echo "3) Looking for .m3u8 streams to download with ffmpeg"
# find remote m3u8s referenced in downloaded HTML files
grep -RhoE "https?://[^\"' >]+\.m3u8" . | sort -u > m3u8-urls.txt || true
if [[ -s m3u8-urls.txt ]]; then
  mkdir -p downloaded_videos
  while read -r url; do
    echo "ffmpeg -i \"$url\" -c copy downloaded_videos/$(basename ${url%.*}).mp4"
    ffmpeg -y -i "$url" -c copy "downloaded_videos/$(basename ${url%.*}).mp4" || echo "ffmpeg failed for $url"
  done < m3u8-urls.txt
else
  echo "No .m3u8 streams found in the mirror."
fi

echo "4) Extract likely embedded video page URLs for yt-dlp (YouTube/Vimeo etc.)"
# crude extract: find iframe srcs and javascript occurrences of youtube/vimeo domains
grep -RhoE "https?://(www\.)?(youtube|vimeo|player\.vimeo|youtu\.be)[^\"' >]+" . | sort -u > embedded-video-urls.txt || true
if [[ -s embedded-video-urls.txt ]]; then
  echo "Use yt-dlp to download these (review first):"
  cat embedded-video-urls.txt
  # Optionally run:
  # yt-dlp -a embedded-video-urls.txt -o 'downloaded_videos/%(title)s.%(ext)s'
else
  echo "No obvious embedded YouTube/Vimeo URLs found."
fi

echo "Done. To browse locally: cd $OUTDIR && python3 -m http.server 8000"

