#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

echo -n "" | zstd -c > "data/valid_archives.zst"
cp "data/valid_archives.zst" "data/invalid_archives.zst"
cp "data/valid_archives.zst" "data/volatile_archives.zst"
