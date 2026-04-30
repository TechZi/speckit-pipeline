#!/usr/bin/env bash
set -euo pipefail

REF="${SPECKIT_PIPELINE_REF:-main}"
REPO="https://github.com/TechZi/speckit-pipeline"

SCRIPT_DIR=""
if [ -f "$0" ] && [ "$(basename -- "$0")" = "install.sh" ]; then
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd || true)"
fi
if [ -n "$SCRIPT_DIR" ] && [ -x "$SCRIPT_DIR/bin/speckit-pipeline" ]; then
  exec "$SCRIPT_DIR/bin/speckit-pipeline" install "$@"
fi

tmp="$(mktemp -d)"
cleanup() { rm -rf "$tmp"; }
trap cleanup EXIT

archive="$tmp/speckit-pipeline.tar.gz"
url="$REPO/archive/refs/heads/$REF.tar.gz"
if ! curl -fsSL "$url" -o "$archive"; then
  url="$REPO/archive/refs/tags/$REF.tar.gz"
  curl -fsSL "$url" -o "$archive"
fi

tar -xzf "$archive" -C "$tmp"
dir="$(find "$tmp" -maxdepth 1 -type d -name 'speckit-pipeline-*' | head -1)"
[ -n "$dir" ] || { echo "Error: failed to unpack speckit-pipeline archive" >&2; exit 1; }
exec "$dir/bin/speckit-pipeline" install "$@"
