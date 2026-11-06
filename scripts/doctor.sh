#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -e .venv || -L .venv ]]; then
  if ! .venv/bin/python -c 'import sys' >/dev/null 2>&1; then
    echo "The project Python environment cannot run on this Mac." >&2
    echo "Rename .venv to preserve it, then run npm run setup to rebuild it." >&2
    exit 1
  fi
  exec .venv/bin/python scripts/doctor.py
fi

# Allow readiness checks before setup, without trusting the global Python shim.
source scripts/find-python.sh
for version in 3.13 3.14; do
  if python_bin="$(resolve_video_python "$version")"; then
    exec "$python_bin" scripts/doctor.py
  fi
done
echo "No runnable Python 3.13 or 3.14 found. Run npm run setup first." >&2
exit 1
