---
name: planning
description: Turn a request into a PRD (what and why) and a sliced plan (how) before any code is written. Use in Plan mode after the environment probe, for any task larger than a one-line fix, and whenever the request is vague. Output is the plan; nothing is implemented until the user approves.
---

# Planning

## Primary bias to correct

Nobody knows exactly what they want, and a plan is a prompt: whatever it leaves vague, the executor will guess.

## Discovery

- Classify first and say it: **spike** (a question; output is an answer, not kept code), **bounded** (a change to a flow that already exists in this repo), or **architectural** (new subsystem or an interface others depend on). In doubt, take the heavier path; hidden complexity upgrades it, nothing downgrades.
- Explore the codebase before asking anything: files, docs, recent commits, patterns, vocabulary. Finding facts is your job; deciding is the user's.
- Make informed defaults and record them as assumptions. Ask only where the answer changes scope, security, or user experience and no reasonable default exists. Five questions maximum per plan.
- Ask in rounds: every question whose prerequisites are settled, numbered, with lettered options, your recommended answer first, and one line on why it matters.
- Elicit, do not author. "I'm assuming X works like Y, right?" is fine; walking the user through a tree of your own choices is not.
- If the request spans several independent subsystems, decompose it into sub-projects first and plan only the first one.
- For architectural work, propose two or three approaches with trade-offs and lead with your recommendation. Cut every feature the goal does not need.

## PRD (what and why)

1. **Problem** — what is wrong or missing, from the user's perspective.
2. **Goal** — one sentence. What exists when this is done.
3. **Glossary** — every domain noun, defined once. The rest of the document uses these terms exactly; a synonym anywhere is a defect.
4. **User stories** — prioritized P1, P2, P3; each independently testable and shippable alone, P1 by itself a viable MVP. Acceptance scenarios as Given / When / Then. Cover primary, alternative, and failure paths, and permissions where relevant.
5. **Functional requirements** — numbered FR-1, FR-2… Each is one testable capability. Ban "gracefully", "robust", "intuitive", "reasonable", "user-friendly", "scalable" unless followed by a number or a condition.
6. **Constraints** — versions, dependencies, naming, platform, performance bounds, budget. Exact values, one line each.
7. **Non-goals** — what this deliberately does not do. The cheapest scope-creep prevention there is.
8. **Success criteria** — measurable and technology-agnostic. Add a counter-metric: what must not get worse.
9. **Assumptions** — every default you chose instead of asking, indexed so the user can veto any of them.
10. **Open questions** — what is still unknown. These become tickets, never silent gaps.

Length scales with stakes: a bounded change gets a page. Padding to look thorough is a defect.

## Plan (how)

- Name the seams the work will be tested at before writing tasks. Prefer existing seams, at the highest level possible. Fewer is better; one is ideal. Confirm them with the user.
- Cut the work into tracer-bullet slices: a narrow but complete path through every layer, verifiable alone. The test: after this slice, a user can do something they could not do before. A slice that only "lays foundation" is a horizontal layer in disguise.
- When slices depend on each other: define contracts first, implement against them, wire last. Executors get names and types from the plan; they never hunt for them.
- Order by blocking edges. Prefactoring that makes the change easy comes first. A wide mechanical refactor is the one exception to vertical slicing: expand, migrate in batches, contract.
- Size in context, not time. A slice touches a handful of files and fits one fresh context window. Too small to review alone: merge. More than five files or two subsystems: split.
- Every slice has five fields: **delivers** (end-to-end behavior, from the user's side), **blocked by**, **files** to create or modify, **interfaces** consumed and produced, **proven by** (an automated command). If no test exists yet, the slice's first step creates it.
- Never reduce scope to fit. "v1", "simplified", "hardcoded for now", "wire later" are plan failures; split the plan and say so instead. The only reasons to split: context cost, missing information, an unshipped dependency. Difficulty is not one.
- No placeholders. "TBD", "add error handling", "handle edge cases", "write tests for the above", "similar to slice N" are plan failures.
- Implementation decisions go in the plan; code snippets do not, except where a prototype produced a shape (schema, state machine, type) that prose cannot carry.
- Present the plan and stop. Nothing is implemented until the user approves.

## Before presenting

- Path classified and announced; at most five questions asked; defaults recorded as assumptions.
- Every user story, FR, and locked user decision maps to a slice. A gap is reported, never dropped.
- Banned adjectives and placeholder phrases searched for and removed.
- Names, types, and signatures match across slices and the glossary.
- Each slice is vertical, fits one context window, and has an automated proof.
- Specificity test: could a different agent, with no memory of this conversation, execute each slice without asking?
- Nothing in the plan that the goal does not require; scope intact or split with the reason named.
