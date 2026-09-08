---
name: delivery-plan
description: Turn a task into a one-page PRD, an architecture sketch, and a sliced build plan with test-first cadence, sized for a 60-minute live session. Use in Plan mode after the environment probe, before any code.
---

# Delivery plan

Purpose: agree on what we are building and in what order before touching code. Output is one document, short enough to read in a minute. I edit it; you do not start building until I say "go".

## Step 1: PRD (max 15 lines)

- Goal: one sentence, who it is for, what changes for them.
- Users and the 2-3 flows that matter, each as "user does X, sees Y".
- In scope for this session: the smallest set of flows that makes the app real.
- Out of scope, stated explicitly, with one reason each.
- Acceptance: for each in-scope flow, the observable check (a curl, a screen, a test name).

If the task statement is ambiguous, ask one question with a default, then continue with the default.

## Step 2: Architecture sketch (max 12 lines)

- Runtime and framework, chosen from what the environment probe found. No new runtime installs.
- Layout: entry point, routes, services, storage, tests, one line each.
- Data model: entities and fields, in a code block.
- API surface: method, path, request, response, error codes, one line per endpoint.
- Storage: SQLite behind one interface. Say the interface.
- Preview: which port, how to start it, how to check it.

## Step 3: Slices (3-5, in ship order)

Each slice is 5-10 minutes and ends with something running. For each slice:

1. Name and the acceptance check it satisfies.
2. Files touched.
3. Test first: the test names to write before the code.
4. Risk line: what could be wrong here, and how we would know.

Slice 1 is always: skeleton runs, health endpoint answers, one test passes, preview shows something.
Last slice is always: README (install, run, test), cleanup, final full test run.

## Cadence during build (Agent mode)

- Per slice: write the tests, show the diff, stop. On "go", write the code, show the diff, stop. On "go", run tests and the app, report, write the risk line.
- If a slice grows past its files list, stop and say so. We resize; we do not push through.
- Never skip a run to save time. A slice without a run is not done.

## Time budget for a 60-minute session

- 0-3 min: environment probe, helpers.
- 3-12 min: PRD, architecture, slices. I edit and say "go".
- 12-50 min: slices, test-first, run after each.
- 50-60 min: README, full test run, walkthrough of what was cut and why.
