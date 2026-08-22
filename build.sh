#!/bin/sh
# Builds the compiled Tailwind CSS. Requires the standalone `tailwindcss`
# binary on PATH (macOS arm64: download `tailwindcss-macos-arm64` from
# https://github.com/tailwindlabs/tailwindcss/releases, v4.x).
set -eu
tailwindcss -i src/input.css -o assets/main.css --minify
