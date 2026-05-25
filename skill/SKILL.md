---
name: borg
description: Bootstrap the borg PM operating system into the current project — a folder-based task queue, PM protocol, product context, and workbook for coordinating coding agents. Use this skill whenever the user says "load up borg", "init borg", "start borg", "set up borg", "wire up borg", or describes wanting to set up a PM agent workflow, task queue, .agent/ folder, or structured way for spawning subagents on a project. Also trigger when the user names work to do AND mentions borg, PM agent, or task queue in the same breath, even if they don't say "init" — that means they want bootstrap plus initial task seeding in one go.
---

# borg

borg installs a minimal PM operating system into the current project. it gives the project a generic PM protocol, a place for project-specific context, a workbook for durable knowledge, and a folder-based task queue. a PM agent then runs against that structure.

the skill itself only handles bootstrap. the PM agent is a separate agent the user spawns afterwards.

## when to invoke

trigger on:
- "load up borg" / "init borg" / "start borg" / "wire up borg in this repo"
- "set up the PM system here" + any mention of borg
- the user naming work ("we're gonna do x, y, z") in the same message as borg / PM / agent / task queue — that's a combined bootstrap-plus-seed request

do not trigger on:
- a generic mention of tasks or PM without a borg/agent/.agent reference
- the user asking the PM agent to do something — that's the runtime, not bootstrap. only invoke borg to install or reset the structure.

## what to do when invoked

### 1. check state

look for `.agent/` in cwd.

- if absent → proceed to scaffold.
- if present → don't overwrite. ask the user whether they want to (a) add new tasks to the existing queue, (b) re-read the protocol, or (c) reset (destructive, confirm twice before running with `--force`).

knowing why matters: borg's whole premise is that the `.agent/` folder accumulates project memory (workbook entries, rejected approaches, work logs). silently overwriting it erases the thing that makes borg useful past day one.

### 2. scaffold

run the scaffold script. it copies `assets/.agent/` into `<cwd>/.agent/` and refuses to overwrite without `--force`.

```sh
<path-to-skill>/scripts/scaffold.sh
```

the script is preferred over manual file copies because it preserves the folder layout (including empty status folders via `.gitkeep`) and gives consistent error messages on conflicts.

### 3. interview (short, max 4 questions)

use AskUserQuestion to fill `PRODUCT-CONTEXT.md`. ask only what isn't already obvious from the conversation. the goal is to give the future PM agent enough project-specific context that it doesn't need to re-derive it from chat history.

minimum fields:
- **what is this project, in one sentence**
- **primary verification command** (e.g. `pnpm test`, `cargo test`, `xcodebuild ... build`) — accept "none yet" but do not leave blank
- **any hard constraint the PM agent must not violate** (e.g. "don't touch the auth middleware") — include the reason if the user gives one
- **anything already tried and rejected** (optional, can defer to first work session)

write the answers into the corresponding sections of `PRODUCT-CONTEXT.md`. preserve the file's section headings.

### 4. seed initial tasks (only if the user named pre-scoped work)

borg's PM agent is both taskmaster and executor (see `assets/.agent/PM-PROTOCOL.md` → scoping). the bootstrap only seeds tasks when the user already named pre-scoped items.

- **named pre-scoped work** ("we're gonna do x, y, z" where x/y/z are concrete tasks): create one file per item in `.agent/tasks/ready/`. use `.agent/templates/task.md`. number sequentially: `001-<slug>.md`. fill in `Goal` from what the user said. leave `Acceptance checks`, `Files / areas`, and `Work log` as prompts for the PM agent.
- **end-state goal** ("get the app to ship feature Y", "fix the slow pages"): do NOT seed task files. leave the queue empty and tell the user the PM agent will scope it. they'll brief the PM in a fresh session and the PM writes the task files itself.

do not invent acceptance criteria the user didn't give you — that's the PM's job, with or without scoping.

### 5. hand off

reply with 2–3 sentences and a copy-pasteable handoff prompt. pick the handoff variant based on whether the queue is seeded:

**if `tasks/ready/` has files:**

> you are the PM agent for this project. read `.agent/PM-PROTOCOL.md`, `.agent/PRODUCT-CONTEXT.md`, `.agent/WORKBOOK.md`, then list `.agent/tasks/ready/` and `.agent/tasks/doing/`. pick the next task and propose how you'll execute it. do not implement code yourself — delegate to subagents per the protocol.

**if the queue is empty (end-state goal case):**

> you are the PM agent for this project. read `.agent/PM-PROTOCOL.md`, `.agent/PRODUCT-CONTEXT.md`, `.agent/WORKBOOK.md`. i'm going to brief you on what we're trying to ship. once we agree on scope, write the task files into `.agent/tasks/ready/` following the protocol's scoping section, then begin execution. if our scoping conversation gets long, tell me and we'll reset you to a fresh session — the task files are the contract.

mention that new tasks go in `.agent/tasks/ready/` and status changes by `mv`-ing files between status folders.

## what NOT to do

- **don't edit `PM-PROTOCOL.md` to fit the project.** it's generic on purpose so the PM agent's behavior stays consistent across projects. project-specific rules go in `PRODUCT-CONTEXT.md`. mixing the two makes both harder to update.
- **don't create an `INDEX.md` or status table.** status is the folder a task file lives in. a separate index is a thing to forget to update; the filesystem can't lie.
- **don't try to "be" the PM agent in the same turn you scaffolded.** the user should spawn a fresh agent for that role. cold context is the point — the PM agent's strength is reading the protocol and workbook without the bootstrap conversation's baggage.
- **don't install worktrees, dispatcher scripts, checker loops, or reviewer agents during bootstrap.** V1 is queue + protocol only. those layers exist on the roadmap but bloat the bootstrap if added upfront. wait for the user to ask.

## example invocation

**user:** "load up borg in this repo. we're gonna fix the slow login page, add a settings export, and clean up the dead routes."

**assistant actions:**
1. scaffolds `.agent/` via the script
2. asks 3 questions: project one-liner, verify command, any hard constraints
3. creates `tasks/ready/001-fix-slow-login.md`, `002-add-settings-export.md`, `003-clean-up-dead-routes.md` with just the `Goal` field filled
4. replies with the handoff prompt and a note that PRODUCT-CONTEXT.md may need more detail before the PM agent runs

**user:** "set up borg" (in a project where `.agent/` already exists)

**assistant actions:**
1. detects existing `.agent/`
2. asks: add new tasks, re-read protocol, or reset? does not touch anything until answered
