#!/bin/bash
# Build window-background-immediate probe (bare Inform 6 / Glulx, no library).
#
# Tool locations (override any of these):
#   INFORM6       path to inform6
#   INFORM_APP    macOS: Inform.app bundle (used only to derive INFORM6)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/bgcolor.inf"
OUT="$SCRIPT_DIR/bgcolor.ulx"

uname_s="$(uname -s 2>/dev/null || echo unknown)"
case "$uname_s" in
	Darwin)
		INFORM_APP="${INFORM_APP:-/Applications/Inform.app}"
		: "${INFORM6:=$INFORM_APP/Contents/MacOS/inform6}"
		;;
	*)
		: "${INFORM6:=$(command -v inform6 2>/dev/null || echo inform6)}"
		;;
esac

if [ ! -e "$INFORM6" ] && ! command -v "$INFORM6" >/dev/null 2>&1; then
	echo "Missing inform6: $INFORM6" >&2
	echo "On macOS set INFORM_APP or INFORM6." >&2
	exit 1
fi

if [ ! -f "$SRC" ]; then
	echo "Missing source: $SRC" >&2
	exit 1
fi

echo "==> inform6 (Glulx)"
echo "    INFORM6=$INFORM6"
"$INFORM6" -G "$SRC" "$OUT"

echo
echo "Built: $OUT"
ls -lh "$OUT"
