# agent-skills

The three files I attach to every coding-agent session. Agent Skills format (SKILL.md with frontmatter), portable across Claude Code, cloud IDE agents, Cursor, Codex.

- `environment-probe/` learn the box in one command (`scripts/probe.sh`), report in five lines, then stop. Ships `scripts/docs.sh` for library docs via the context7 REST API.
- `delivery-plan/` one-page PRD, architecture sketch, 3-5 slices with test-first cadence, sized for a 60-minute session.
- `agent-conventions/` how I work with an agent, and what the code has to look like.

Bootstrap on any box:

```bash
[ -d .agent/skills ] || git clone -q --depth 1 https://github.com/arthurkatcher/agent-skills .agent/skills
```

Then reference them as `@.agent/skills/<name>/SKILL.md`.
