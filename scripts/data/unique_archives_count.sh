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
  if [ ! -f "$file" ]; then
    echo -n "" | zstd -c > "$file"
  fi
done

valid_count=$(zstdcat "$VALID_ARCHIVES" | cut -d " " -f 2 | sort | uniq | wc -l)
invalid_count=$(zstdcat "$INVALID_ARCHIVES" | cut -d " " -f 2 | sort | uniq | wc -l)
volatile_count=$(zstdcat "$VOLATILE_ARCHIVES" | cut -d " " -f 2 | sort | uniq | wc -l)

echo "unique archives count: valid - ${valid_count}, invalid - ${invalid_count}, volatile - ${volatile_count}"
