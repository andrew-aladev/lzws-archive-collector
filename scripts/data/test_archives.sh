#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

CPU_COUNT=$(grep -c "^processor" "/proc/cpuinfo" || sysctl -n "hw.ncpu")

cd "../.."

TMP_PATH="$(pwd)/tmp"
TMP_SIZE="1024"

./scripts/temp/mount.sh "$TMP_PATH" "$TMP_SIZE"
cd "$TMP_PATH"

# We need to create release builds for all possible dictionaries.
for dictionary in "linked-list" "sparse-array"; do
  build="${dictionary}-build"
  mkdir -p "$build"
  cd "$build"

  find . -depth \( -name "CMake*" -o -name "*.cmake" \) -exec rm -rf {} +

  cmake "${LZWS_PATH:-../../../}" \
    -DLZWS_COMPRESSOR_DICTIONARY="$dictionary" \
    -DLZWS_SHARED=OFF \
    -DLZWS_STATIC=ON \
    -DLZWS_CLI=ON \
    -DLZWS_TESTS=OFF \
    -DLZWS_EXAMPLES=OFF \
    -DLZWS_MAN=OFF \
    -DCMAKE_BUILD_TYPE="RELEASE" \
    -DCMAKE_C_FLAGS_RELEASE="-Ofast -march=native"
  make clean
  make -j${CPU_COUNT}

  cd ".."
done

cd ".."

ARCHIVE_URLS="data/archive_urls.zst"
VALID_ARCHIVES="data/valid_archives.zst"
INVALID_ARCHIVES="data/invalid_archives.zst"
VOLATILE_ARCHIVES="data/volatile_archives.zst"

FILES=(
  "$ARCHIVE_URLS"
  "$VALID_ARCHIVES"
  "$INVALID_ARCHIVES"
  "$VOLATILE_ARCHIVES"
)

for file in "${FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo -n "" | zstd -c > "$file"
  fi
done

./lib/test_archives/main.rb \
  "$ARCHIVE_URLS" \
  "$VALID_ARCHIVES" \
  "$INVALID_ARCHIVES" \
  "$VOLATILE_ARCHIVES"
