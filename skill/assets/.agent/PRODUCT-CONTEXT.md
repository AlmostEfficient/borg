# Product Context

project-specific context for the PM agent. edit this file as the project evolves. the PM-PROTOCOL stays generic; everything project-shaped lives here.

## what this project is

<one or two sentences. what does this codebase do, who is it for>

## primary goal right now

<what is the current focus. what would "good progress this week" look like>

## verification commands

<the commands a worker must run before moving a task to review/. examples:>
<- `pnpm test`>
<- `pnpm typecheck`>
<- `xcodebuild -project foo.xcodeproj -scheme foo -destination 'generic/platform=iOS Simulator' build CODE_SIGNING_ALLOWED=NO`>

if there are no verification commands yet, say so explicitly. don't leave it blank.

## hard constraints

<things the PM agent must never violate without explicit user reopening. examples:>
<- don't touch the auth middleware (legal/compliance>
<- don't change the public API of the `core/` package>
<- don't replace the custom sticky header (protects against a native Apple bug)>

each constraint should include a brief "why" so future agents can judge edge cases.

## already tried and rejected

<things that have been tested and don't work, with the reason. agents need to see dead ends so they don't repeat them.>

## design / voice notes

<if there's a design.md or voice.md elsewhere in the repo, point to it here. if there are quick style rules, write them inline.>

## stakeholders / external context

<who cares about this work outside the repo. deadlines. external dependencies. anything that shapes priority.>
