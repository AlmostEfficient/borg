#!/usr/bin/env bash
# scaffold borg's .agent/ structure into a target project.
# usage: scaffold.sh [target_dir]
# default target is $PWD. refuses to overwrite an existing .agent/ unless --force.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="$SKILL_DIR/assets/.agent"

FORCE=0
TARGET="$PWD"

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help)
      echo "usage: scaffold.sh [target_dir] [--force]"
      exit 0
      ;;
    *) TARGET="$arg" ;;
  esac
done

if [ ! -d "$ASSETS_DIR" ]; then
  echo "error: assets/.agent not found at $ASSETS_DIR" >&2
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "error: target dir does not exist: $TARGET" >&2
  exit 1
fi

DEST="$TARGET/.agent"

if [ -d "$DEST" ] && [ "$FORCE" -ne 1 ]; then
  echo "error: $DEST already exists. pass --force to overwrite (destructive)." >&2
  exit 1
fi

if [ "$FORCE" -eq 1 ] && [ -d "$DEST" ]; then
  rm -rf "$DEST"
fi

cp -R "$ASSETS_DIR" "$DEST"

echo "borg scaffolded into $DEST"
echo "next: fill out $DEST/PRODUCT-CONTEXT.md, drop tasks into $DEST/tasks/ready/, spawn a PM agent pointed at $DEST/PM-PROTOCOL.md"
