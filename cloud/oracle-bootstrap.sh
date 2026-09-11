#!/usr/bin/env bash
set -euo pipefail

# Lite OmniRoute on an Oracle Always Free (or any) Docker host.
# Run as a user that can use docker.

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" || true
fi

if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
  echo "Install Docker Compose plugin, then re-run."
  exit 1
fi

DIR="${HOME}/omniroute-lite"
mkdir -p "$DIR"
cd "$DIR"

if [[ -z "${INITIAL_PASSWORD:-}" ]]; then
  INITIAL_PASSWORD="$(head -c 24 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 20)"
  echo "Generated INITIAL_PASSWORD. Save this: ${INITIAL_PASSWORD}"
fi

cat > docker-compose.yml <<'EOF'
services:
  omniroute:
    image: diegosouzapw/omniroute:latest
    container_name: omniroute
    restart: unless-stopped
    stop_grace_period: 40s
    ports:
      - "20128:20128"
    environment:
      INITIAL_PASSWORD: "${INITIAL_PASSWORD}"
      OMNIROUTE_MEMORY_MB: "512"
      NODE_OPTIONS: "--max-old-space-size=512"
      DATA_DIR: "/app/data"
    volumes:
      - omniroute-data:/app/data

volumes:
  omniroute-data:
EOF

export INITIAL_PASSWORD
echo "INITIAL_PASSWORD=${INITIAL_PASSWORD}" > .env

docker compose pull
docker compose up -d

echo "OmniRoute should be at http://$(curl -s ifconfig.me || echo HOST):20128"
echo "Dashboard password is INITIAL_PASSWORD in ${DIR}/.env"
echo "Open TCP 20128 (or put Caddy on 443) in the Oracle security list."
