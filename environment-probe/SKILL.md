---
name: environment-probe
description: Probe a fresh sandbox or cloud dev box in under a minute, confirm what is already known about it, and report before any code is written. Use at the very start of a session, and again if a run command or port stops working.
---

# Environment probe

Goal: in one command, learn what this box has and report it in five lines. No code, no installs, no fixes during the probe.

## Step 0: bring the skills onto the box

Attachments live only in the current chat; files on disk live for the whole session and can be @-mentioned from any chat. So the first command of the session is:

```bash
[ -d .agent/skills ] || git clone -q --depth 1 https://github.com/arthurkatcher/agent-skills .agent/skills; ls .agent/skills
```

If the clone fails (no network), say so in one line and ask me to attach the three SKILL.md files instead. Do not retry more than once.

After that, reference skills as `@.agent/skills/<name>/SKILL.md` in every new chat. Frame requests as coding work ("run the probe", "draft the plan for this task").

## Step 1: run the probe

```bash
bash .agent/skills/environment-probe/scripts/probe.sh
```

Read-only. Prints runtime versions, files, tasks.json, README run lines, package manifests, ports, sudo, CPU/RAM/disk, network reachability (npm, PyPI, GitHub, docs API), and which services exist.

## Step 2: report (five lines, nothing else)

1. Runtime: which of Node / Python is present, versions.
2. Scaffold: empty root, or what is already there (app, tests, README, tasks.json) and the documented run command.
3. Preview: which port the run command uses, and whether it is one of the open ports.
4. Network and sudo: yes/no each.
5. Recommendation: the stack for this task in one sentence, using what is already installed.

Then stop and wait for the plan.

## Docs helper (use only when an API surface is uncertain or something fails)

```bash
bash .agent/skills/environment-probe/scripts/docs.sh search <library>            # find the library id
bash .agent/skills/environment-probe/scripts/docs.sh get <library-id> <topic>    # focused snippets, ~2500 tokens
```

Example: `docs.sh search flask` gives `/pallets/flask`; `docs.sh get /pallets/flask "error handling" 1500`. Read the error first; fetch docs second. Never paste more than one docs call per problem into the chat.

## Known facts about this kind of sandbox (verify with the probe, do not re-derive)

- Project root is `/projects/challenge` on this platform. The "run project" terminal tab runs `.vscode/tasks.json`.
- 2 vCPU, 12 GB RAM, ~13 GB disk. Passwordless sudo, apt-get works.
- Full outbound internet: npm, PyPI, GitHub, raw.githubusercontent.com, context7.com.
- Python images: Python 3.13 + uv + git, Node may be absent. Node images ship their own Node. Installing Node via apt takes ~2 min and gives Node 18; last resort only.
- No Docker, Postgres, or Redis. Everything runs in-process.
- Browser pane renders what listens on 3000, 3030, 5000, 6001, 8000 or 8080. Bind to 0.0.0.0.
- SQLite is the default store. Python `sqlite3` is built in. Node: `npm i sqlite3` (prebuilt) works; `better-sqlite3` fails on Node 18; Node 22+ has `node:sqlite`.
- `npm i` and `uv pip install` are fast. Every dependency needs a one-line reason.

## Rules during the probe and after

- Do not touch environment variables that are not ours. Platform keys in the env belong to the sandbox assistant, not the task.
- Do not install global tooling "to be safe". Install what the current slice needs, when it needs it.
- One server per port. `pkill -f "node|flask|uvicorn"` before a restart.
