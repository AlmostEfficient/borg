# borg

a tiny PM operating system for coding agents.

the premise: your PM agent doesn't need to be smarter. it needs scaffolding around it — a queue, a protocol, a place to write things down, and rules about who does what. borg is that scaffolding as a skill you can drop into any project.

## what's in here

repo root is the skill itself. `SKILL.md` + `assets/` (templates that get scaffolded) + `scripts/scaffold.sh` (the bootstrap script).

## install

borg works as a skill in any agent harness that supports the SKILL.md format. easiest path is via [vercel-labs/skills](https://github.com/vercel-labs/skills):

```sh
npx skills add AlmostEfficient/borg -g -a '*'
```

that installs borg globally across every detected agent harness (Claude Code, Codex, Cursor, Cline, etc.) — one command, agent-agnostic.

manual install (if you don't use the skills CLI):

```sh
# clone wherever
git clone https://github.com/AlmostEfficient/borg.git ~/borg

# point each harness at it (symlink, so edits stay live)
ln -s ~/borg ~/.claude/skills/borg
ln -s ~/borg ~/.codex/skills/borg
ln -s ~/borg ~/.cursor/skills/borg

# optional: borg CLI on PATH for shell/scripted use
ln -s ~/borg/scripts/scaffold.sh ~/.local/bin/borg
```

## usage

in any project, say:

> load up borg and let's tackle x, y, z

the skill scaffolds `borg/` into the cwd, asks a few questions to fill `PRODUCT-CONTEXT.md`, optionally drops task files into `tasks/ready/` if you named pre-scoped work, and tells you how to spawn the PM agent.

if you gave an end-state goal instead of a task list, the PM agent does the scoping itself — borg is taskmaster + orchestrator.

## the shape

borg gives every project:

```
borg/
  PM-PROTOCOL.md       # how the PM agent should behave (generic, don't edit much)
  PRODUCT-CONTEXT.md   # what this project is, constraints, verification commands
  WORKBOOK.md          # durable cross-task findings, decisions, rejected approaches
  tasks/
    ready/             # claimable
    doing/             # in flight
    review/            # checks passed, needs human or reviewer agent
    done/              # merged
    failed/            # gave up after retries
  templates/
    task.md            # task file template
```

status is a folder. moving a file changes status. no INDEX.md to forget to update.

## roadmap

borg V1 is bootstrap + protocol + folder queue. the rest, in order of leverage:

### build next

1. **checker loop** — script reads the verify command from `PRODUCT-CONTEXT.md`, runs it after a worker reports done, on failure pipes logs back to the same worker, retries up to N times, then moves the task to `review/` or `failed/`. shape is generic; the command is stack-specific. real leverage item — turns the worker→test contract from conversational to mechanical.

### outside borg's scope

2. **tmux process management** — borg works inside or outside tmux. not enforced. optional later: `borg claim <id>` spawning a named tmux session per worker.

### deferred (revisit when context changes)

3. **worktrees** — `borg/worktrees/<task-id>/` per task. deferred because borg is mobile-first right now and hardware-bound stacks (iOS, React Native/Expo) can only have one runtime install testable at a time. worktrees still help for parallel *code editing* on disjoint areas, but small win until non-mobile work shows up.
4. **notifications** — ntfy/Slack/macOS notif on `review/` or `failed/` status changes. deferred because terminal-watching is fine for now.
5. **automated reviewer** — script triggers a cold-context reviewer when status hits `review/`. currently PM-managed (the protocol tells the PM to spawn an aggregate reviewer at end-of-batch). undecided whether automating wins long-term — leaving the door open.
6. **dispatcher** — small script that claims `ready/` tasks, spawns agents, moves task files between status folders, and reports completion. deferred until the manual PM loop proves exactly which handoffs should be automated.

add these only when the absence hurts.

## philosophy

- markdown is the interface. scripts are the control system. git is the truth.
- the PM agent does decomposition, prioritization, and handoff text. not state management, not retries, not validation.
- one task file should let a fresh agent continue without reading chat history.
- rejected approaches stay in the workbook, marked rejected and why. agents need to know what's been tried.
