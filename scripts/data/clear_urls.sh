#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

VALID_PAGE_URLS="data/valid_page_urls.zst"
INVALID_PAGE_URLS="data/invalid_page_urls.zst"
ARCHIVE_URLS="data/archive_urls.zst"

FILES=(
  "$VALID_PAGE_URLS"
  "$INVALID_PAGE_URLS"
  "$ARCHIVE_URLS"
)

for file in "${FILES[@]}"; do
  echo -n "" | zstd -c > "$file"
done
