#!/bin/sh
set -eu

ARCH="${ARCH:-arm-none-eabi}"

cd "$1"

strip -v --strip-all --remove-section=.comment bin/* "$ARCH"/bin/* || true
find libexec -type f -print0 | xargs -0 -r strip -v --strip-all --remove-section=.comment || true
find lib -name '*.so*' -print0 | xargs -0 -r strip -v --strip-unneeded --remove-section=.comment || true

find "lib/gcc/$ARCH" "$ARCH/lib" -type f \( -name '*.a' -o -name '*.o' \) -print0 | xargs -0 -L1 -r -t "./bin/$ARCH-strip" --strip-debug --remove-section=.comment || true
