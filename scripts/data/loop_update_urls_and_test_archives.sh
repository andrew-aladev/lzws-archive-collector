#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

UPDATE_URLS_TIMES=10

while true; do
  for i in $(seq $UPDATE_URLS_TIMES); do
    ./update_urls.sh
  done

  ./test_archives.sh
done
