#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

TMP_PATH="$(pwd)/tmp"
TMP_SIZE="1024"

./scripts/temp/mount.sh "$TMP_PATH" "$TMP_SIZE"

VALID_PAGE_URLS="data/valid_page_urls.zst"
INVALID_PAGE_URLS="data/invalid_page_urls.zst"
ARCHIVE_URLS="data/archive_urls.zst"

FILES=(
  "$VALID_PAGE_URLS"
  "$INVALID_PAGE_URLS"
  "$ARCHIVE_URLS"
)

for file in "${FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo -n "" | zstd -c > "$file"
  fi
done

./lib/update_urls/main.rb \
  "$VALID_PAGE_URLS" \
  "$INVALID_PAGE_URLS" \
  "$ARCHIVE_URLS"
