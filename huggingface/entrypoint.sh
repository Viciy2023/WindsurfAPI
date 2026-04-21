#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/app"
STATE_DIR="/data/windsurf/state"
OPT_DIR="/opt/windsurf"
LS_PATH="${LS_BINARY_PATH:-/opt/windsurf/language_server_linux_x64}"

write_env_file() {
  cat > "$1" <<EOF
PORT=7860
API_KEY=${API_KEY}
${CODEIUM_API_KEY:+CODEIUM_API_KEY=${CODEIUM_API_KEY}}
${CODEIUM_AUTH_TOKEN:+CODEIUM_AUTH_TOKEN=${CODEIUM_AUTH_TOKEN}}
${CODEIUM_EMAIL:+CODEIUM_EMAIL=${CODEIUM_EMAIL}}
${CODEIUM_PASSWORD:+CODEIUM_PASSWORD=${CODEIUM_PASSWORD}}
CODEIUM_API_URL=${CODEIUM_API_URL:-https://server.self-serve.windsurf.com}
DEFAULT_MODEL=${DEFAULT_MODEL:-claude-4.5-sonnet-thinking}
MAX_TOKENS=${MAX_TOKENS:-8192}
LOG_LEVEL=${LOG_LEVEL:-info}
LS_BINARY_PATH=/opt/windsurf/language_server_linux_x64
LS_PORT=${LS_PORT:-42100}
${DASHBOARD_PASSWORD:+DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}}
EOF
}

require_env() {
  local name="$1"
  if [ -z "${!name:-}" ]; then
    echo "[entrypoint] Missing required environment variable: $name" >&2
    exit 1
  fi
}

ensure_json_file() {
  local path="$1"
  local content="$2"
  if [ ! -f "$path" ]; then
    printf '%s\n' "$content" > "$path"
  fi
}

require_env API_KEY
if [ -z "${CODEIUM_API_KEY:-}" ] && [ -z "${CODEIUM_AUTH_TOKEN:-}" ]; then
  echo "[entrypoint] No preloaded Windsurf credentials found. You can add accounts later via Dashboard, token login, or batch import."
fi

mkdir -p "$STATE_DIR" "$OPT_DIR/data/db" /tmp/windsurf-workspace

if [ ! -f "$LS_PATH" ]; then
  echo "[entrypoint] Language server binary not found at $LS_PATH" >&2
  exit 1
fi
chmod +x "$LS_PATH"

ENV_OUTPUT="$STATE_DIR/.env.tmp"
write_env_file "$ENV_OUTPUT"
mv "$ENV_OUTPUT" "$STATE_DIR/.env"

ensure_json_file "$STATE_DIR/accounts.json" '[]'
ensure_json_file "$STATE_DIR/proxy.json" '{"global":null,"perAccount":{}}'
ensure_json_file "$STATE_DIR/model-access.json" '{"mode":"all","list":[]}'
ensure_json_file "$STATE_DIR/runtime-config.json" '{}'

ln -sfn "$STATE_DIR/.env" "$APP_DIR/.env"
ln -sfn "$STATE_DIR/accounts.json" "$APP_DIR/accounts.json"
ln -sfn "$STATE_DIR/proxy.json" "$APP_DIR/proxy.json"
ln -sfn "$STATE_DIR/model-access.json" "$APP_DIR/model-access.json"
ln -sfn "$STATE_DIR/runtime-config.json" "$APP_DIR/runtime-config.json"

exec node src/index.js
