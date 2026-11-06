#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
composition="${1:-PruebaHabitacion}"
port="${VIDEO_PREVIEW_PORT:-3000}"
if ! .venv/bin/python -c 'import sys' >/dev/null 2>&1; then
  echo "Run npm run setup first to create the project Python environment." >&2
  exit 1
fi
# A static Remotion preview avoids filesystem watchers in restricted environments.
# This builds the interactive preview; it does not render or export an MP4.
(cd studio && npx --no-install remotion bundle src/index.ts)
echo "Open http://localhost:${port}/?/${composition}"
exec .venv/bin/python -m http.server "$port" --bind 127.0.0.1 --directory studio/build
