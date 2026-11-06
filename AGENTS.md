# AI-video-editor-DC

Use Remotion for the master timeline, HyperFrames for standalone motion graphics,
FFmpeg/FFprobe for media preparation and delivery, local OpenAI Whisper for captions,
and yt-dlp for user-provided reference URLs.

## Tooling

- Run `npm run doctor` to inspect readiness; `npm run setup` installs missing dependencies.
- Read available official Remotion skills before authoring or rendering compositions.
- Use official HyperFrames skills when available; avoid duplicating tool documentation.
- No custom agents are required initially. Consider delegation only for independent
  footage analysis, motion graphics, or final QA when the edit warrants it.
- Do not install paid services or upload footage externally without user authorization.

## Media and editing

- Preserve files in `raw_footage/`. Keep reference downloads in `references/`.
- Use `work/` for proxies and temporary renders, `assets/` for supplied brand/music
  assets, `transcripts/` for caption data, and `exports/` for deliveries.
- Inspect resolution, frame rate, duration, rotation, audio and color metadata before editing.
- Keep a per-video edit brief with audience, hook, CTA, aspect ratio, duration and references.
- Retain word-level Whisper JSON alongside SRT/VTT. Review names, prices, places,
  punctuation and timing manually. Rebase caption timestamps after timeline cuts.
- Use one master timeline. HyperFrames graphics enter Remotion as rendered assets;
  check alpha support and frame rate before choosing overlay formats.
- Build proxies for heavy footage. Treat HDR footage explicitly before SDR output.
- Keep output dimensions, FPS and color handling consistent across both renderers.
- Preview before export. Render only when requested. Do not publish automatically.
- Before delivery, inspect scene changes, captions, mobile safe areas, audio clipping,
  ending/CTA, and exported metadata. Record checks that could not run.
- Reuse scripts and lockfiles; avoid repeated lossy encodes. Track source code in Git,
  keep large media out of Git, and recommend a separate footage backup.
