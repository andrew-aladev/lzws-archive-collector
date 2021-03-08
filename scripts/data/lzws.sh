#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../../tmp"

dictionary="$1"
bignum_library="$2"
shift 2

"./${dictionary}-${bignum_library}/result/lzws-static" $@
