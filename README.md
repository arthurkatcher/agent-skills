# agent-skills

The three files I attach to every coding-agent session. Agent Skills format (SKILL.md with frontmatter), portable across Claude Code, cloud IDE agents, Cursor, Codex.

- `environment-probe/` learn the box in one command, report in five lines, set up the docs helper, then stop.
- `delivery-plan/` one-page PRD, architecture sketch, 3-5 slices with test-first cadence, sized for a 60-minute session.
- `agent-conventions/` how I work with an agent, and what the code has to look like.

Bootstrap on any box:

```bash
git clone --depth 1 https://github.com/arthurkatcher/agent-skills .agent/skills
```

Then reference them as `@.agent/skills/<name>/SKILL.md`.
