#!/usr/bin/env bash
# Expose a local port as a public https URL with a Cloudflare quick tunnel. No account, no token, dies with the shell.
#   share.sh [port]   (default 8000)
# Use in the last minutes to hand out a link. Run in a second terminal tab so the main shell stays free.
set -e
port="${1:-8000}"
bin=/tmp/cloudflared
if [ ! -x "$bin" ]; then
  curl -sL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o "$bin"
  chmod +x "$bin"
fi
"$bin" tunnel --url "http://localhost:${port}" > /tmp/tunnel.log 2>&1 &
for i in $(seq 1 30); do
  url=$(grep -o -E 'https://[a-z0-9-]+\.trycloudflare\.com' /tmp/tunnel.log | head -1)
  [ -n "$url" ] && { echo "$url"; exit 0; }
  sleep 1
done
echo "tunnel did not come up; see /tmp/tunnel.log"; exit 1
