#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

empty_data=$(echo "" | zstd -c)

echo "$empty_data" > "data/valid_archives.zst"
echo "$empty_data" > "data/invalid_archives.zst"
echo "$empty_data" > "data/volatile_archives.zst"
