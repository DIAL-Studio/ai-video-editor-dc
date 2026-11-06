#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

for tool in node npm git ffmpeg ffprobe; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing prerequisite: $tool. Install it before rerunning setup." >&2
    exit 1
  fi
done
node -e 'if (Number(process.versions.node.split(".")[0]) < 22) { console.error("Node 22+ required"); process.exit(1); }'

# Fail early if the package registry cannot be reached. Keep npm writes local.
export npm_config_cache="$PWD/.npm-cache"
npm ping --fetch-retries=0 --fetch-timeout=15000

source scripts/find-python.sh
video_python_version="${VIDEO_PYTHON_VERSION:-3.13}"
case "$video_python_version" in
  3.13|3.14) ;;
  *) echo "Use VIDEO_PYTHON_VERSION=3.13 (default) or 3.14 (experimental for Whisper)." >&2; exit 1 ;;
esac
if [[ -e .venv || -L .venv ]]; then
  if ! .venv/bin/python -c 'import sys; assert ".".join(map(str, sys.version_info[:2])) == sys.argv[1]' "$video_python_version" 2>/dev/null; then
    echo "Existing .venv is broken or uses another Python version. Preserve/rename it before rerunning setup for Python $video_python_version." >&2
    exit 1
  fi
else
  python_bin="$(resolve_video_python "$video_python_version")" || python_bin=""
  if [[ -z "$python_bin" ]] && command -v brew >/dev/null 2>&1; then
    brew install "python@${video_python_version}"
    python_bin="$(resolve_video_python "$video_python_version")" || python_bin=""
  fi
  if [[ -z "$python_bin" ]]; then
    echo "Install Python $video_python_version, then rerun setup." >&2
    exit 1
  fi
  echo "Creating project environment with $python_bin"
  "$python_bin" -m venv .venv
fi
.venv/bin/python --version
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m pip freeze > requirements.lock.txt

if [[ -f package-lock.json ]]; then npm ci; else npm install; fi
if [[ ! -f studio/package.json ]]; then
  if [[ -e studio ]]; then
    echo "studio/ exists without package.json; inspect it before scaffolding." >&2
    exit 1
  fi
  npx --yes create-video@latest --yes --blank --no-tailwind studio
fi
if [[ -f studio/package-lock.json ]]; then
  npm --prefix studio ci
else
  npm --prefix studio install
fi

echo "Dependencies installed. Installing Remotion's browser runtime next."
(cd studio && npx remotion browser ensure)
.venv/bin/python scripts/doctor.py
echo "Setup complete. Start the timeline with: npm run studio"
echo "Optional official HyperFrames skills: npx hyperframes skills update"
echo "Whisper model weights download on the first transcription."
