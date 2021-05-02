#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

VALID_ARCHIVES="data/valid_archives.zst"
INVALID_ARCHIVES="data/invalid_archives.zst"
VOLATILE_ARCHIVES="data/volatile_archives.zst"

FILES=(
  "$VALID_ARCHIVES"
  "$INVALID_ARCHIVES"
  "$VOLATILE_ARCHIVES"
)

for file in "${FILES[@]}"; do
  echo -n "" | zstd -c > "$file"
done
