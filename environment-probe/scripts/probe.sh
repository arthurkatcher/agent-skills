#!/usr/bin/env bash
# One-shot environment probe. Read-only. Prints raw facts; the agent turns them into the five-line report.
cd "${1:-.}" || exit 1
echo "NODE=$(node -v 2>&1) NPM=$(npm -v 2>&1) NPX=$(npx -v 2>&1) PY=$(python3 -V 2>&1) UV=$(uv -V 2>&1 | cut -c1-9) GIT=$(git --version 2>&1 | cut -c1-18)"
echo "PWD=$(pwd)"
echo "FILES: $(ls -a | tr '\n' ' ')"
echo "TASKS: $(cat .vscode/tasks.json 2>/dev/null | tr -d '\n ' | cut -c1-400)"
echo "README_RUN: $(grep -i -n -E 'npm|node |flask|uvicorn|django|port|localhost|run' README.md 2>/dev/null | head -6 | tr '\n' ' ' | cut -c1-400)"
echo "PKG: $(cat package.json 2>/dev/null | tr -d '\n ' | cut -c1-300)"
echo "PYDEPS: $(cat requirements.txt pyproject.toml 2>/dev/null | tr '\n' ' ' | cut -c1-200)"
echo "PORTS=${OPEN_PORTS:-unknown} SUDO=$(sudo -n true 2>/dev/null && echo yes || echo no) CPU=$(nproc 2>/dev/null) MEM_MB=$(free -m 2>/dev/null | awk '/Mem/{print $2}') DISK=$(df -h . 2>/dev/null | tail -1 | awk '{print $4}')"
echo "NET_NPM=$(curl -s -m 4 -o /dev/null -w %{http_code} https://registry.npmjs.org/express) NET_PYPI=$(curl -s -m 4 -o /dev/null -w %{http_code} https://pypi.org/simple/flask/) NET_GH=$(curl -s -m 4 -o /dev/null -w %{http_code} https://raw.githubusercontent.com) NET_DOCS=$(curl -s -m 4 -o /dev/null -w %{http_code} https://context7.com/api/v1/search?query=express)"
echo "SERVICES: docker=$(command -v docker || echo no) psql=$(command -v psql || echo no) redis=$(command -v redis-server || echo no) sqlite3=$(command -v sqlite3 || echo no) py_sqlite=$(python3 -c 'import sqlite3;print(sqlite3.sqlite_version)' 2>/dev/null || echo no)"
echo "PROBE_DONE"
