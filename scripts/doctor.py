"""Check the local toolchain without downloading packages or model weights."""
from pathlib import Path
import json
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    failures = []
    for name in ("node", "npm", "git", "ffmpeg", "ffprobe"):
        executable = shutil.which(name)
        print(f"{'OK' if executable else 'MISSING'} {name}: {executable or 'not found'}")
        if not executable:
            failures.append(name)
    for label, relative in (("HyperFrames", "node_modules/hyperframes/package.json"),
                            ("Remotion", "studio/node_modules/remotion/package.json")):
        path = ROOT / relative
        if path.is_file():
            print(f"OK {label}: {json.loads(path.read_text())['version']}")
        else:
            print(f"MISSING {label}")
            failures.append(label)
    python = ROOT / ".venv/bin/python"
    if python.exists():
        result = subprocess.run(
            [str(python), "-c", "import sys; print('OK project Python:', sys.version.split()[0]); "
             "import whisper, yt_dlp; import importlib.metadata as m; "
             "print('OK Whisper:', m.version('openai-whisper')); "
             "print('OK yt-dlp:', m.version('yt-dlp'))"],
            capture_output=True, text=True, timeout=60,
        )
        print(result.stdout.strip() if result.returncode == 0 else result.stderr.strip())
        if result.returncode:
            failures.append("Python tools")
    else:
        print("MISSING project Python environment (Whisper and yt-dlp)")
        failures.append("Python tools")
    print("\nReady for media checks." if not failures else "\nIncomplete setup: " + ", ".join(failures))
    return bool(failures)


if __name__ == "__main__":
    sys.exit(main())
