#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

valid_count=$(zstdcat "data/valid_archives.zst" | cut -d " " -f 2 | sort | uniq | wc -l)
invalid_count=$(zstdcat "data/invalid_archives.zst" | cut -d " " -f 2 | sort | uniq | wc -l)
volatile_count=$(zstdcat "data/volatile_archives.zst" | cut -d " " -f 2 | sort | uniq | wc -l)

echo "unique archives count: valid - ${valid_count}, invalid - ${invalid_count}, volatile - ${volatile_count}"
