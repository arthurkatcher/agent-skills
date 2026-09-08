---
name: agent-conventions
description: How Arthur works with a coding agent and what the code it writes has to look like. Attach at the start of every session and apply on every plan, diff, and run. Use whenever writing, changing, or reviewing code in this session.
---

# Agent conventions

How I work with a coding agent, and what the code it writes has to look like.
Short on purpose: read once, enforced on every diff.

## How we work

1. Plan before code. First message restates the task in my words, lists constraints, and cuts the work into thin slices in ship order. I edit the plan before anything runs.
2. One slice at a time. Each slice ends with something runnable. No slice touches more than a handful of files.
3. Show the diff, then stop. I read every change before it lands. If I say "smaller", split it.
4. Run it before calling it done. Tests, a curl, or the app in the browser. "It should work" is not a status.
5. Name the risk. Every slice ends with one line: what could be wrong here, and how we would know.
6. Ask when the spec is ambiguous. One question, with a default. Do not invent requirements.
7. No new dependency without a reason I would repeat to a reviewer.
8. When you are unsure, say so. A confident wrong answer costs more than a question.

## What the code looks like

- Names say what a thing is. No abbreviations, no `data2`, no `helper`.
- Small functions, one job each. If a function needs a comment to explain its flow, split it.
- Structure someone can navigate without a guided tour: routes, services, storage in separate files; entry point obvious.
- Errors are handled where they can be acted on, and returned as proper status codes with a clear message. No bare try/except, no swallowed exceptions.
- Validate at the boundary (request in), trust the inside.
- State lives in one place with one interface. Storage is swappable behind that interface: SQLite today, Postgres tomorrow, same calls.
- Tests cover the behaviour the task asked for, in the order the task listed it. Happy path first, then each error case.
- No cleverness. Boring, readable code beats a smart one-liner every time.
- No dead code, no TODOs left behind, no commented-out blocks.
- README with three lines: how to install, how to run, how to test.

## Definition of done for a slice

- Runs from a clean start with the documented command.
- Tests for that slice pass.
- Diff reviewed by me, no unrelated changes.
- Risk line written.
