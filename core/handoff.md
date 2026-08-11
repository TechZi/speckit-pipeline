# Speckit Pipeline Handoff

Use this file when switching between Codex, Claude Code, Qoder, and Cursor.
The pipeline is designed to resume from repository files, not from chat history.

## Before handing off

1. Finish the current stage if possible.
2. Update `specs/<feature>/.speckit-pipeline-state.json`.
3. Append a short entry to `specs/<feature>/.speckit-pipeline-log.md`.
4. If implementation has started, record the latest verification and convergence outcome.
5. Report the exact next stage and any blockers.

## When receiving a handoff

1. Read `.specify/feature.json` to identify the current feature when present.
2. Read `specs/<feature>/.speckit-pipeline-state.json`.
3. Read the generated Spec Kit artifacts listed in state.
4. Check `git status` before editing.
5. Continue from `nextStage`, unless the user explicitly asks to start a new feature.

If convergence previously appended tasks, resume at `implement`. If implementation verification passed but convergence has not run, resume at `converge`. Treat a feature as complete only when verification passed and convergence reports `converged`.

## If state is missing

Inspect `spec.md`, `plan.md`, and `tasks.md` in the current feature directory. If you infer the next stage, label the result as inferred. If the inference is unsafe, pause and ask the user whether to resume an existing feature or start a new one.
