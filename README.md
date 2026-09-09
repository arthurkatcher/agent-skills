# agent-skills

The files I bring into every coding-agent session. Agent Skills format (SKILL.md with frontmatter), portable across Claude Code, cloud IDE agents, Cursor, Codex.

- `environment-probe/` learn the box in one command (`scripts/probe.sh`), write `.agent/NOTES.md`, report in five lines, then stop. Ships `scripts/share.sh` for a public URL via a Cloudflare quick tunnel.
- `planning/` discovery, PRD (problem, goal, glossary, stories, FRs, constraints, non-goals, success criteria, assumptions, open questions), then tracer-bullet slices with delivers / blocked by / files / interfaces / proven by. Plan mode, stop before code.
- `coding-practices/` always-on rules for writing, testing, and reviewing code: test first, seams not internals, deep modules, nothing claimed without a fresh run.
- `docs-lookup/` current library docs from the terminal via the context7 REST API (`scripts/docs.sh`), one call per problem.

Bootstrap on any box:

```bash
[ -d .agent/skills ] || git clone -q --depth 1 https://github.com/arthurkatcher/agent-skills .agent/skills
```

Then reference them as `.agent/skills/<name>/SKILL.md`. Session memory lives in `.agent/NOTES.md`.
