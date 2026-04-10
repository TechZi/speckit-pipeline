---
name: speckit-pipeline
description: Orchestrate one concrete feature through the Spec Kit workflow in repositories that already have official Spec Kit Codex skills installed. Use this skill when the user wants one feature taken from requirement to implementation with minimal manual step-by-step invocation. Run specify, clarify, plan, tasks, analyze, checklist, and implement in order, and pause only for true blocking clarification, missing prerequisites, critical artifact inconsistency, or verification failure. Do not use this skill for multi-feature backlog scheduling, roadmap planning, or repo-wide release orchestration.
---

# Spec Kit Pipeline

## Purpose

This skill is a thin orchestrator for a **single feature**.

It does not replace official Spec Kit skills.  
It coordinates them in a safe, gated order so the user does not need to manually trigger each step.

Expected underlying skills:
- $speckit-constitution
- $speckit-specify
- $speckit-clarify
- $speckit-plan
- $speckit-tasks
- $speckit-analyze
- $speckit-checklist
- $speckit-implement

## When to use

Use this skill when:
- the repository already uses Spec Kit
- the user wants one concrete feature developed end-to-end
- the user wants fewer manual workflow steps
- implementation is expected after planning, unless the user explicitly asks for planning only

Do not use this skill when:
- the task is backlog prioritization across multiple features
- the task is release management or multi-PR orchestration
- the task is pure brainstorming with no intention to create Spec Kit artifacts
- official Spec Kit skills are not installed in this repository
- the repository has not been initialized for Spec Kit and the user is not asking to initialize it

## Required operating model

You must follow this model:

1. Work on exactly one feature at a time.
2. Prefer official Spec Kit skill outputs as the source of truth.
3. Do not jump directly from user request to implementation.
4. Do not silently skip clarify, analyze, or verification gates.
5. Keep updates concise and only at stage boundaries or when blocked.
6. Always return the current stage, generated artifacts, assumptions, blockers, and next step.

## Preconditions

Before starting the pipeline, verify the following:

1. The repository has Spec Kit initialized.
2. Official Spec Kit skills are available in this repo.
3. A constitution exists, or the user is okay with creating one now.
4. The feature request is concrete enough to begin specification.

If constitution is missing and the project clearly intends to use Spec Kit, run `$speckit-constitution` before continuing.

If prerequisites are missing, stop and explain exactly what is missing.

## Pipeline stages

Run the following stages in order for one feature.

### Stage 0 — intake

Interpret the user's request into one concrete feature request.

At the start, state:
- the feature request you are using
- whether this is implementation mode or planning-only mode
- any assumptions you are making before specification

### Stage 1 — specify

Invoke:
- `$speckit-specify`

Goal:
- create the feature spec and associated feature directory / branch

After this stage:
- summarize the resulting feature scope in 5–10 lines
- identify the generated feature directory if available
- identify any major uncertainty that should be clarified before planning

### Stage 2 — clarify

Invoke when needed:
- `$speckit-clarify`

Rules:
- If there is material ambiguity that could change the plan or implementation, run clarify.
- If ambiguity is minor and does not threaten correctness, continue but explicitly record assumptions.
- If clarify reveals blocking questions that only the user can answer, stop and ask only those questions.

Do not use clarify as a generic brainstorming stage.
Use it only to remove meaningful ambiguity.

### Stage 3 — plan

Invoke:
- `$speckit-plan`

Goal:
- translate the approved or clarified spec into an implementation plan tied to the repo’s real stack and constraints

After this stage:
- summarize the technical approach
- name the main architectural decisions
- call out any repo constraints, compatibility risks, or missing dependencies

### Stage 4 — tasks

Invoke:
- `$speckit-tasks`

Goal:
- generate an execution-ready task list with dependency-aware ordering

After this stage:
- summarize the task breakdown
- note whether the tasks are small enough for iterative execution
- identify any task that looks too large or underspecified

### Stage 5 — analyze

Invoke:
- `$speckit-analyze`

Goal:
- check cross-artifact consistency and coverage before implementation

Rules:
- If analyze finds critical inconsistencies, stop and repair the artifacts before moving on.
- If findings are minor and non-blocking, continue but clearly record them.

Always treat artifact inconsistency as a real gate.
Do not proceed to implementation on top of obviously conflicting artifacts.

### Stage 6 — checklist

Invoke when useful or required:
- `$speckit-checklist`

Use this stage when:
- the feature is high-impact
- the project constitution defines required quality gates
- the user asks for stronger pre-implementation review

If required quality items are missing, treat them as a gate.

### Stage 7 — implement

Invoke only after all previous gates are satisfied:
- `$speckit-implement`

Rules:
- Only implement after specification, planning, task generation, and analysis are coherent.
- If the user asked for planning only, stop before this stage.
- After implementation, run the repository’s required verification stack.

Verification must include, as applicable:
- unit tests
- integration tests
- lint / static checks
- schema / contract checks
- smoke checks
- end-to-end checks when relevant

Never claim completion without verification results.

## Mandatory gates

Stop and return control to the user when any of the following is true:

1. Blocking clarification is required.
2. Constitution or repo constraints conflict with the plan.
3. Analyze reports critical artifact inconsistency.
4. Required prerequisites or tools are missing.
5. Verification fails and cannot be confidently repaired in the same run.
6. The feature turns out to be multiple distinct features and must be split.

When blocked, do not produce a vague status.
State exactly:
- current stage
- blocker
- why it blocks progress
- what concrete input or action is required next

## Output contract

At every stage boundary, report:

- **Current stage**
- **Artifacts generated or updated**
- **Key assumptions**
- **Risks or blockers**
- **Exact next step**

When the full pipeline completes, report:

- the final stage reached
- the created or updated spec artifacts
- implementation status
- verification results
- remaining risks or follow-up work
- whether the feature is ready for PR / review

## Behavioral constraints

- Stay disciplined and stage-based.
- Prefer narrow progress over broad but vague progress.
- Do not fabricate repository state.
- Do not claim official Spec Kit outputs were produced unless they were actually produced.
- Do not skip implementation gates just because the feature seems easy.
- Do not convert this into a multi-feature orchestrator.

## Use of references

Before enforcing a gate, consult `references/gating-rules.md` for:
- gate definitions
- blocking vs non-blocking conditions
- pause / continue rules
- final completion criteria

## Suggested invocation pattern

Typical explicit use:

- `$speckit-pipeline implement this feature end-to-end`
- `$speckit-pipeline plan this feature but stop before implement`
- `$speckit-pipeline run the full workflow and pause only on blocking issues`

## Final reminder

This skill is for **one feature only**.

For multi-feature queueing, prioritization, retries, or repository-wide long-running automation, use an outer orchestrator that calls this skill as its single-feature execution unit.