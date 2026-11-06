#!/usr/bin/env bash
# Source this file; resolve an executable, never an unchecked pyenv shim.
resolve_video_python() {
  local target="$1" candidate resolved pyenv_root
  local -a candidates=("python${target}" "python3")
  if command -v brew >/dev/null 2>&1; then
    candidate="$(brew --prefix "python@${target}" 2>/dev/null)" || candidate=""
    [[ -z "$candidate" ]] || candidates+=("${candidate}/bin/python${target}")
  fi
  if command -v pyenv >/dev/null 2>&1; then
    pyenv_root="$(pyenv root 2>/dev/null)" || pyenv_root=""
    if [[ -n "$pyenv_root" ]]; then
      # Search installed base interpreters without changing pyenv's active version.
      for candidate in "$pyenv_root"/versions/"${target}".*/bin/python; do
        [[ ! -x "$candidate" ]] || candidates+=("$candidate")
      done
    fi
  fi
  for candidate in "${candidates[@]}"; do
    if resolved="$("$candidate" -c 'import os, sys; assert ".".join(map(str, sys.version_info[:2])) == sys.argv[1]; print(os.path.realpath(sys.executable))' "$target" 2>/dev/null)"; then
      [[ -n "$resolved" && -x "$resolved" ]] || continue
      printf '%s\n' "$resolved"
      return 0
    fi
  done
  return 1
}
