#!/usr/bin/env bash
# animate-core/install.sh
# ─────────────────────────────────────────────────────────────────────────────
# CHANGELOG (newest first)
# ─────────────────────────────────────────────────────────────────────────────
#   2026-04-30  Initial standalone installer
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_BIN="$_ROOT/cli/bin"
_USER_BIN="${HOME}/bin"
_RC="${HOME}/.bashrc"

printf '\n  animate-core install\n  ────────────────────\n\n'

command -v python3 &>/dev/null || { printf '  x  python3 required\n'; exit 1; }

if ! python3 -c "from PIL import Image" 2>/dev/null; then
    printf '  ~  Installing Pillow...\n'
    pip install Pillow --break-system-packages --quiet
    printf '  ✓  Pillow installed\n'
fi

mkdir -p "$_USER_BIN"
chmod +x "$_BIN"/*

if ! grep -qF "$_BIN" "$_RC" 2>/dev/null; then
    printf '\n# animate-core\nexport PATH="$PATH:%s"\n' "$_BIN" >> "$_RC"
    printf '  +  Added cli/bin to PATH\n'
else
    printf '  ✓  Already in PATH\n'
fi

for f in "$_BIN"/*; do
    ln -sf "$f" "$_USER_BIN/$(basename "$f")"
    printf '  ~  Linked: %s\n' "$(basename "$f")"
done

printf '\n  Done.\n  Run: source ~/.bashrc\n\n'
