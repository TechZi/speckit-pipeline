# Gating Rules for Spec Kit Pipeline

This document defines when the pipeline must pause, when it may continue, and what qualifies as completion.

## 1. Gate philosophy

The pipeline should automatically advance through routine stages, but it must pause at a small number of high-value gates.

The purpose of a gate is to prevent the agent from amplifying an early mistake into a larger implementation error.

A good gate should be:
- specific
- observable
- explainable to the user
- directly tied to execution risk

## 2. Blocking vs non-blocking issues

### Blocking issues

A blocking issue is one that makes the next stage unsafe or materially unreliable.

Treat the following as blocking:

- the feature request is too ambiguous to produce a meaningful spec
- clarification reveals questions that only the user can answer
- project constitution is missing when the repo clearly depends on it
- the generated plan conflicts with explicit project constraints
- artifacts disagree on core scope, architecture, or acceptance criteria
- required tools, dependencies, or skills are unavailable
- verification fails in a way that cannot be repaired confidently in the same run
- the request is actually multiple distinct features and should be split

When an issue is blocking:
- stop the pipeline
- summarize the exact reason
- identify the current stage
- state the smallest next action needed to unblock progress

### Non-blocking issues

A non-blocking issue is one that should be documented but does not make the next stage unsafe.

Treat the following as non-blocking unless they materially affect correctness:

- small wording ambiguity that does not change behavior
- low-risk assumptions about naming or organization
- minor analyze findings with clear local fixes
- checklist recommendations that are useful but not required by constitution
- low-priority refactors or follow-up enhancements

When an issue is non-blocking:
- continue the pipeline
- record the assumption or finding
- surface it in the stage report

## 3. Stage-by-stage gate rules

### Stage: intake

Pause if:
- the request is too vague to identify one concrete feature
- the user is actually asking for backlog strategy rather than feature execution

Continue if:
- a single feature can be reasonably inferred

### Stage: specify

Pause if:
- Spec Kit is not initialized
- official Spec Kit skills are unavailable
- the feature request cannot be mapped into a coherent spec

Continue if:
- a concrete spec artifact is generated
- the feature scope is bounded enough for planning

### Stage: clarify

Pause if:
- there are material ambiguities affecting acceptance criteria, architecture, API shape, data model, or rollout behavior
- only the user can resolve the ambiguity

Continue if:
- unresolved ambiguity is minor and can be handled as an explicit assumption

Rule:
- do not turn clarify into an open-ended workshop
- ask only the minimum blocking questions

### Stage: plan

Pause if:
- the plan conflicts with constitution
- the plan assumes tooling or architecture not present in the repository
- the plan is generic boilerplate rather than codebase-aware guidance

Continue if:
- the plan is compatible with the real repo constraints
- major implementation choices are explicit

### Stage: tasks

Pause if:
- tasks are missing entirely
- tasks are so large that iterative execution is unrealistic
- task ordering is clearly incompatible with dependencies

Continue if:
- tasks are dependency-aware
- tasks can be executed incrementally
- at least one first implementation slice is obvious

### Stage: analyze

Pause if:
- analyze reports critical inconsistency across spec, plan, tasks, contracts, data model, or acceptance criteria
- important scope is missing from downstream artifacts
- implementation would proceed against contradictory instructions

Continue if:
- findings are minor and do not threaten correctness
- the inconsistency is already repaired before implementation begins

### Stage: checklist

Pause if:
- required quality items from constitution or project policy are missing
- the feature is high-impact and lacks mandatory review coverage

Continue if:
- checklist findings are advisory rather than required

### Stage: implement

Pause if:
- earlier required artifacts are missing
- implementation would require inventing scope not supported by the spec
- tests or checks fail in a way that cannot be repaired confidently
- implementation reveals the feature should have been split into multiple features

Continue if:
- the code changes align with the approved artifacts
- required verification passes

## 4. Verification rules

Completion is not the same as code generation.

A feature may be treated as implemented only when:

- code changes are made
- required tests or checks are run
- the observed results are reported
- no known blocking verification failure remains

Verification should include what is relevant for the repository, such as:

- unit tests
- integration tests
- linting
- type checks
- contract validation
- schema validation
- smoke tests
- end-to-end checks

If the repository has explicit validation scripts, use them.

## 5. Assumptions policy

The pipeline may make assumptions only when all of the following are true:

- the assumption is low-risk
- the assumption does not change the product contract
- the assumption does not contradict constitution or repo conventions
- the assumption is reported explicitly to the user

The pipeline must not silently assume:
- acceptance criteria
- rollout strategy
- security requirements
- API compatibility constraints
- destructive migration behavior

## 6. Reporting rules

Every pause or completion report must include:

- current stage
- status: continue / paused / completed
- artifacts generated or updated
- assumptions made
- blockers or risks
- exact next step

Do not report only a generic summary.
The user should be able to resume the pipeline from the report with minimal ambiguity.

## 7. Completion criteria

The pipeline is complete for one feature only when one of these is true:

### Successful completion
- spec, plan, tasks, and required supporting artifacts exist
- required gates have passed
- implementation is finished or intentionally skipped because the user asked for planning-only mode
- required verification has been run
- final status is clearly reported

### Controlled pause
- the pipeline stops at a defined blocking gate
- the blocker is explicit
- the next required action is explicit

Anything else is not completion.

## 8. Non-goals

This pipeline does not manage:
- multiple feature queues
- roadmap prioritization
- cross-feature dependency scheduling
- release trains
- multi-PR merge orchestration
- repo-wide tech debt programs

Those belong to an outer orchestrator.