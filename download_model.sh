#!/usr/bin/env bash
# Download G1-360M_V18.2_PRODUCTION_F16 from Hugging Face.
#
# Rules:
#   - Idempotent — safe to run multiple times without re-downloading.
#   - No credentials required — model is publicly accessible.
#   - Output path matches `_runtime.model_path` in metadata.json.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_DIR="$HERE/model"
MODEL_FILE="$MODEL_DIR/G1-360M_V18.2_PRODUCTION_F16.gguf"

# ── G1-360M V18.2 Production F16 — public Hugging Face URL ─────────────────────
MODEL_URL="https://huggingface.co/gsstec/G1-360M_V18.2_PRODUCTION_F16/resolve/main/G1-360M_V18.2_PRODUCTION_F16.gguf"
# ───────────────────────────────────────────────────────────────────────────────

mkdir -p "$MODEL_DIR"

if [[ -f "$MODEL_FILE" ]]; then
  echo "model already present at $MODEL_FILE — skipping download"
  exit 0
fi

echo "downloading G1-360M_V18.2_PRODUCTION_F16 (~692 MB) from Hugging Face…"
echo "source: $MODEL_URL"
echo "destination: $MODEL_FILE"

if command -v curl > /dev/null 2>&1; then
  curl -L --fail --progress-bar -o "$MODEL_FILE.partial" "$MODEL_URL"
elif command -v wget > /dev/null 2>&1; then
  wget --show-progress -O "$MODEL_FILE.partial" "$MODEL_URL"
else
  echo "error: neither curl nor wget found. Install one and re-run." >&2
  exit 1
fi

mv "$MODEL_FILE.partial" "$MODEL_FILE"
echo "done: $MODEL_FILE"
