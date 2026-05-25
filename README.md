# borg

a tiny PM operating system for coding agents.

the premise: your PM agent doesn't need to be smarter. it needs scaffolding around it — a queue, a protocol, a place to write things down, and rules about who does what. borg is that scaffolding as a skill you can drop into any project.

## what's in here

- `skill/` — the installable skill. symlink or copy this to `~/.claude/skills/borg/` and it becomes invokable as `borg` from any project.

## install

```sh
ln -s /Users/raza/Projects/borg/skill ~/.claude/skills/borg
```

then in any project, say something like:

> load up borg and let's tackle x, y, z

the skill scaffolds `.agent/` into the cwd, asks a few questions to fill `PRODUCT-CONTEXT.md`, drops initial task files into `tasks/ready/`, and tells you how to spawn the PM agent.

## the shape

borg gives every project:

```
.agent/
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

## roadmap (not built yet)

borg V1 is just queue + protocol. these are the obvious next layers, intentionally kept out until V1 proves itself:

- **worktrees**: `.agent/worktrees/<task-id>/` per task, isolates parallel agents.
- **checker loop**: script that runs verification commands and feeds failures back to the agent up to N times.
- **reviewer agent**: cold-context agent that reads the diff + acceptance checks, returns approve/revise/reject.
- **dispatcher**: small script that claims `ready/` tasks, spawns agents in tmux, moves status, notifies on completion.

add these only when the absence hurts.

## philosophy

- markdown is the interface. scripts are the control system. git is the truth.
- the PM agent does decomposition, prioritization, and handoff text. not state management, not retries, not validation.
- one task file should let a fresh agent continue without reading chat history.
- rejected approaches stay in the workbook, marked rejected and why. agents need to know what's been tried.
