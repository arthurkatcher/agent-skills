---
name: coding-practices
description: Always-on rules for writing, changing, testing, and reviewing code in any language. Use on every coding task and before claiming any work is done.
---

# Coding Practices

## Primary bias to correct

Working code is not automatically good code, and a confident claim is not evidence.

## Decision rules

- No production code without a failing test first. The loop, one behavior at a time:
  1. Write the test.
  2. Run it. Confirm it fails, and fails because the behavior is missing, not because of a typo or import error.
  3. Write the least code that makes it pass.
  4. Run the full suite, not just the new test file. Confirm the new test passes and nothing else broke.
  5. Refactor only with the suite green, then run it again.
  Code written before its test is deleted and rewritten from the test.
- Test at seams: the public interface where behavior is observed. Never test private methods, never mock real collaborators over using them; a mock is a last resort, not a convenience. Expected values come from the spec, never from the implementation's own output.
- A test covers one behavior, is named for that behavior, uses realistic inputs, and would fail if the behavior broke. Happy path first, then every error case the task named.
- Never weaken or skip a test to get green. Fix the code or report the conflict.
- Read local context first: conventions, wiring, error style, test style, and whether the logic already exists. Search before you write. Local idiom beats personal preference.
- Put code with the unit that owns the responsibility, not the file that happens to be open. Mirror the existing artifacts. Wire new files in completely.
- One job per unit, describable in one sentence without "and", "also", or "then".
- Prefer deep modules: a lot of behavior behind a small interface. Reject wrappers, helpers, layers, and split-outs that add names without hiding real complexity.
- Dependencies point inward. Business rules never name the database, framework, ORM, or request object; SQL lives in the data layer.
- Deduplicate only code that changes together.
- Names are precise, in domain vocabulary, one term per concept. No `data`, `helper`, `util`, `manager`.
- Functions do one thing at one level of abstraction. No boolean flag parameters, no output parameters, no hidden side effects.
- Errors are handled where a decision can be made, propagated with context otherwise, never swallowed. Validate at the boundary; trust the inside.
- Comments say why, in one to three lines. A comment that explains flow is a request to restructure.
- Every changed line traces to the request. Targeted edits, never whole-file regeneration. Unrelated problems get reported; do not fix them silently.
- No new dependency without a reason you would repeat to a reviewer. Verify every API against the installed version, not memory.
- Nothing left behind: no TODOs for in-scope work, no commented-out blocks, no stubs presented as done.

## Trigger rules

- A function mixes setup, validation, computation, and side effects → split the phases.
- The same few parameters keep traveling together → they are a type.
- One change forces edits in many places → a boundary is missing; fix ownership, not symptoms.
- Adding a helper, layer, or wrapper → prove it removes complexity for callers, or drop it.
- A bug is found → reproduce it with a failing test first, then fix.
- Tempted to rewrite → take the next small behavior-preserving step instead.
- Async, locks, or shared state appear → make ownership, ordering, and cleanup explicit; test the failure paths.

## Before claiming done

1. Identify the command that proves the claim.
2. Run it fresh and in full.
3. Read the whole output.
4. Confirm it actually supports the claim.
5. Only then state it, without "should", "probably", "seems to".

A bug fix is proven by the original symptom failing, then passing. A subagent's report is a claim, not a verification. If a check cannot run, say what did not run and what risk remains.

## Before and after shipping

Run the full test suite before any deploy; a red suite blocks the deploy. After the deploy, verify against the running system, not the code, and report exactly what was checked and what was not.

## Final checklist

- Test seen failing before the code?
- Every changed line traces to the request?
- New code in the owning unit, wired in completely?
- Verification run fresh, output quoted, gaps named?
- Suite green before and after?
- One risk line: what could still be wrong, and how would we know?
