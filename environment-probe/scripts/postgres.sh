#!/usr/bin/env bash
# Install and start PostgreSQL on this box, create an app role and database, print the connection URL.
#   postgres.sh [port] [dbname]     defaults: 5432 app
# Idempotent: safe to run twice. Needs passwordless sudo and apt-get (both confirmed on this platform).
set -euo pipefail
PORT="${1:-5432}"; DB="${2:-app}"; ROLE="$DB"; PASS="$DB"

echo "== 1/5 apt sources: disable third-party repos that break apt-get update"
sudo mkdir -p /etc/apt/disabled-sources
for f in /etc/apt/sources.list.d/*google* /etc/apt/sources.list.d/*chrome*; do
  [ -e "$f" ] && sudo mv "$f" /etc/apt/disabled-sources/ && echo "   moved $f"
done || true
sudo apt-get update -qq 2>&1 | grep -v -E "^W:|^N:" || true

echo "== 2/5 install"
if ! command -v pg_ctlcluster >/dev/null 2>&1; then
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq postgresql postgresql-contrib >/dev/null
fi
PGVER=$(ls /etc/postgresql | sort -V | tail -1)
CONF="/etc/postgresql/${PGVER}/main/postgresql.conf"
echo "   postgresql ${PGVER}"

echo "== 3/5 configure port ${PORT} and local access"
sudo sed -i "s/^#\?port = .*/port = ${PORT}/" "$CONF"
sudo sed -i "s/^#\?listen_addresses = .*/listen_addresses = 'localhost'/" "$CONF"
HBA="/etc/postgresql/${PGVER}/main/pg_hba.conf"
grep -q "host all all 127.0.0.1/32 md5" "$HBA" || echo "host all all 127.0.0.1/32 md5" | sudo tee -a "$HBA" >/dev/null

echo "== 4/5 start"
sudo service postgresql restart >/dev/null 2>&1 || sudo pg_ctlcluster "$PGVER" main restart
for i in $(seq 1 20); do pg_isready -h localhost -p "$PORT" -q && break; sleep 1; done
pg_isready -h localhost -p "$PORT"

echo "== 5/5 role and database"
sudo -u postgres psql -p "$PORT" -tAc "SELECT 1 FROM pg_roles WHERE rolname='${ROLE}'" | grep -q 1 || \
  sudo -u postgres psql -p "$PORT" -qc "CREATE ROLE ${ROLE} WITH LOGIN PASSWORD '${PASS}';"
sudo -u postgres psql -p "$PORT" -tAc "SELECT 1 FROM pg_database WHERE datname='${DB}'" | grep -q 1 || \
  sudo -u postgres createdb -p "$PORT" -O "$ROLE" "$DB"
PGPASSWORD="$PASS" psql -h localhost -p "$PORT" -U "$ROLE" -d "$DB" -tAc "SELECT 'connected as ' || current_user || ' to ' || current_database();"

echo
echo "DATABASE_URL=postgresql://${ROLE}:${PASS}@localhost:${PORT}/${DB}"
echo "POSTGRES_READY"
