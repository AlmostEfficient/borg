# Task: <short title>

## Goal

what should be true when this is done. one or two sentences. falsifiable.

## Context

why this matters. what surrounding work it connects to. anything a fresh agent needs to make sense of the goal without reading chat history.

## Acceptance checks

- [ ] <concrete, verifiable thing>
- [ ] <another concrete thing>
- [ ] verification command from PRODUCT-CONTEXT.md passes

## Evidence Contract

what counts as proof this task is done.

- **primary signal**: the one check this task is judged by.
- **supporting signals**: secondary checks that add confidence.
- **invalid / insufficient**: things that look like proof but aren't. recurring examples: typecheck-passes doesn't mean it runs on device; simulator results don't decide physical-device perf; per-task green doesn't mean the batch composes.

if the task has no evidence beyond acceptance checks, say so explicitly. don't leave this blank — that's how agents waste cycles on the wrong metric after a compaction.

## Files / areas

likely involved:
- `path/to/file.ext`

do not touch:
- `path/to/locked.ext` — reason

## Suggested agent

implementation | investigation | verification | review

## Constraints

anything specific to this task that overrides general behavior. inherits from `PRODUCT-CONTEXT.md` constraints by default.

## Work log

append-only. dated. one entry per meaningful change.

### YYYY-MM-DD — <what happened>

what was tried. what was learned. what's next.

## Findings

durable facts discovered during this task. if a finding will bind future work, promote it to `WORKBOOK.md` and remove it from here. don't double-store.

## Status notes

current blocker, open question, or "ready for review by X". short.
