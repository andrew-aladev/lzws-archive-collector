#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../../tmp"

dictionary="$1"
shift

"./${dictionary}-build/result/lzws-static" $@
