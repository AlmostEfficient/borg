#!/usr/bin/env bash
# scaffold borg's borg/ structure into a target project.
# usage: borg [target_dir]
#   --force --yes-really-delete-borg : overwrite an existing borg/ (destructive)
# default target is $PWD. refuses to overwrite without BOTH destructive flags.

set -euo pipefail

# resolve symlinks (borg CLI is typically symlinked into ~/.local/bin or similar)
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="$SKILL_DIR/assets/borg"

FORCE=0
CONFIRM=0
TARGET="$PWD"

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --yes-really-delete-borg) CONFIRM=1 ;;
    -h|--help)
      cat <<EOF
usage: borg [target_dir]
  scaffolds borg/ into target_dir (default: \$PWD).
  refuses to overwrite an existing borg/ without both:
    --force --yes-really-delete-borg
  (two flags required because deleting borg/ erases workbook history,
  task files, work logs — borg's project memory.)
EOF
      exit 0
      ;;
    *) TARGET="$arg" ;;
  esac
done

if [ ! -d "$ASSETS_DIR" ]; then
  echo "error: assets/borg not found at $ASSETS_DIR" >&2
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "error: target dir does not exist: $TARGET" >&2
  exit 1
fi

DEST="$TARGET/borg"

if [ -d "$DEST" ]; then
  if [ "$FORCE" -ne 1 ] || [ "$CONFIRM" -ne 1 ]; then
    echo "error: $DEST already exists." >&2
    echo "to overwrite, pass BOTH --force AND --yes-really-delete-borg." >&2
    echo "this deletes the existing workbook, task files, and work logs — borg's project memory." >&2
    exit 1
  fi
  rm -rf "$DEST"
fi

cp -R "$ASSETS_DIR" "$DEST"

echo "borg scaffolded into $DEST"
echo "next: fill out $DEST/PRODUCT-CONTEXT.md, drop tasks into $DEST/tasks/ready/, spawn a PM agent pointed at $DEST/PM-PROTOCOL.md"
