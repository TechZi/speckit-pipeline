# Speckit Pipeline Core v0.2.0

This is the shared pipeline core used by Codex, Claude Code, Qoder, and Cursor wrappers.
The wrapper that invoked this file declares the current adapter name.

## Purpose

Run exactly one concrete feature through a gated Spec Kit workflow:

```text
intake -> specify -> clarify -> plan -> tasks -> analyze -> checklist -> implement
```

The pipeline does not replace official Spec Kit commands or skills. It coordinates them, records progress in repository files, and makes cross-tool handoff reliable.

## Required inputs

Before acting, read:

- `.specify/pipeline/adapters.json`
- `.specify/pipeline/state-schema.json`
- `.specify/pipeline/handoff.md`
- `references/gating-rules.md` when available

If those files are not installed in `.specify/pipeline/`, use the copies beside this core file.

## Startup mode

Determine whether this invocation is `new` or `resume`.

Use `new` when:

- the user provides a concrete new feature request
- the user says new, start, create, build, or implement with a concrete request
- no incomplete feature-local state exists

Use `resume` when:

- the user says continue, resume, 接着, 继续, or 恢复
- the user provides no new feature request and the current feature has incomplete state

Pause on conflict when:

- incomplete state exists and the user's input also looks like a new feature request

When paused on conflict, state the existing feature, the new request, and ask the user to choose resume existing or start new.

## State files

For each feature, maintain:

```text
specs/<feature>/.speckit-pipeline-state.json
specs/<feature>/.speckit-pipeline-log.md
```

The state file must use schema version `0.2.0` and include:

- feature
- branch when known
- currentStage
- completedStages
- nextStage
- status
- planningOnly
- lastTool
- lastUpdated
- artifacts
- assumptions
- blockers
- verification

Update state and log after every stage boundary and before any planned handoff.

## Adapter resolution

Use the current wrapper adapter to resolve stage execution.

For each stage:

1. Resolve the official Spec Kit artifact path from `adapters.json`.
2. If native invocation is supported by the current tool, invoke the configured command.
3. If native invocation is unavailable or unsafe, read the resolved artifact and execute its instructions directly.
4. If the artifact is missing, pause with a missing prerequisite error.

Do not run `specify integration switch`.
Do not mutate `.specify/integration.json`.
Do not assume the active Spec Kit integration matches the current AI coding tool.

## Stage rules

### intake

Interpret the user's input as one feature request. If the request is multiple independent features, pause and ask for a split.

### specify

Run the official Spec Kit specify stage. Record generated feature directory, branch, and spec artifact.

### clarify

Run clarify only when material ambiguity could change plan or implementation. If only the user can answer, pause with the minimal blocking questions.

### plan

Run the official plan stage. Confirm the plan respects the repository constitution and real project constraints.

### tasks

Run the official tasks stage. Confirm tasks are dependency-aware and actionable.

### analyze

Run analyze before implementation. Critical inconsistencies block implementation until repaired.

### checklist

Run checklist when the feature is high-impact, the project constitution requires it, or the user asks for stronger pre-implementation review.

### implement

Implement only after specify, plan, tasks, and analyze are coherent. Run the repository's required verification stack and record results.

## Reporting contract

At every stage boundary, report:

- Current stage
- Status: new, in_progress, paused, blocked, or completed
- Artifacts generated or updated
- Key assumptions
- Risks or blockers
- Exact next step

Never claim official Spec Kit outputs were produced unless they were actually produced. Never claim implementation completion without verification results.
