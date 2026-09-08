---
name: environment-probe
description: Probe a fresh sandbox or cloud dev box in under a minute, confirm what is already known about it, and report before any code is written. Use at the very start of a session, and again if a run command or port stops working.
---

# Environment probe

Goal: in one command, learn what this box has and report it in five lines. No code, no installs, no fixes during the probe.

## Step 0: bring the skills onto the box (do this before the probe)

Attachments live only in the current chat; files on disk live for the whole session and can be @-mentioned from any chat. So the first command of the session is:

```bash
git clone --depth 1 https://github.com/arthurkatcher/agent-skills .agent/skills && ls .agent/skills
```

If the clone fails (no network), say so in one line and ask me to attach the three SKILL.md files instead. Do not retry more than once.

After that, reference skills as `@.agent/skills/<name>/SKILL.md` in every new chat. Requests that use them must be framed as coding work ("run the probe", "draft the plan for this task"); the assistant refuses to read attachments for non-coding requests.

## Run this first

```bash
echo "NODE=$(node -v 2>&1) NPM=$(npm -v 2>&1) PY=$(python3 -V 2>&1) UV=$(uv -V 2>&1 | cut -c1-9)"; \
echo "PWD=$(pwd) FILES: $(ls -a | tr '\n' ' ')"; \
echo "TASKS: $(cat .vscode/tasks.json 2>/dev/null | tr -d '\n ' | cut -c1-400)"; \
echo "README_RUN: $(grep -i -n -E 'npm|node |flask|uvicorn|port|localhost|run' README.md 2>/dev/null | head -6 | tr '\n' ' ')"; \
echo "PKG: $(cat package.json 2>/dev/null | tr -d '\n ' | cut -c1-300)"; \
echo "PORTS=$OPEN_PORTS SUDO=$(sudo -n true 2>/dev/null && echo yes || echo no)"; \
echo "NET=$(curl -s -m 4 -o /dev/null -w %{http_code} https://registry.npmjs.org/express)"
```

## Report format (five lines, nothing else)

1. Runtime: which of Node / Python is present, versions.
2. Scaffold: empty root, or what is already there (app, tests, README, tasks.json) and the documented run command.
3. Preview: which port the run command uses; must be one of 3000, 3030, 5000, 6001, 8000, 8080.
4. Network and sudo: yes/no each.
5. Recommendation: the stack for this task in one sentence, using what is already installed.

Then stop and wait for the plan.

## Known facts about this sandbox (verify, do not re-derive)

- Project root is `/projects/challenge`. The "run project" terminal tab runs `.vscode/tasks.json`.
- 2 vCPU, 12 GB RAM, ~13 GB disk. Passwordless sudo, apt-get works.
- Full outbound internet: npm, PyPI, GitHub, raw.githubusercontent.com, context7.com.
- Python images: Python 3.13 + uv + git, no Node. Node images ship their own Node. Installing Node via apt takes ~2 min and gives Node 18; last resort only.
- No Docker, Postgres, or Redis. Everything runs in-process.
- Browser pane renders what listens on 3000, 3030, 5000, 6001, 8000 or 8080. Bind to 0.0.0.0.
- SQLite is the default store. Python `sqlite3` is built in. Node: `npm i sqlite3` (prebuilt) works; `better-sqlite3` fails on Node 18; Node 22+ has `node:sqlite`.
- `npm i` and `uv pip install` are fast. Every dependency needs a one-line reason.

## Helpers (20 seconds, right after the report)

One shell function so docs lookups are a single call. No MCP: this harness does not load MCP servers, so the terminal is the integration point.

```bash
cat >> ~/.bashrc <<'H'
docs() { curl -s -m 15 "https://context7.com/api/v1/$1?type=txt&topic=$2&tokens=${3:-2500}"; }
H
source ~/.bashrc
docs expressjs/express routing 800 | head -20   # smoke test
```

Library ids come from `curl -s "https://context7.com/api/v1/search?query=<lib>"` (field `id`, e.g. `/expressjs/express`, `/pallets/flask`). Use `docs` only when an API surface is uncertain or something fails, never as a substitute for reading the error.

## Rules during the probe and after

- Do not touch environment variables that are not ours. Platform keys in the env belong to the sandbox assistant, not the task.
- Do not install global tooling "to be safe". Install what the current slice needs, when it needs it.
- One server per port. `pkill -f "node|flask|uvicorn"` before a restart.
- Fetch docs only for a specific API surface, only when something fails: `curl` a raw GitHub or context7 URL.
