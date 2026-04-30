---
name: speckit-pipeline
description: Run one Spec Kit feature through a gated, cross-tool pipeline that can resume across Codex, Claude Code, Qoder, and Cursor.
---

# Speckit Pipeline

You are running the cross-tool Spec Kit Pipeline with adapter: codex.

Before doing any feature work:

1. Read `core/pipeline.md` when this skill is installed as an environment-level skill, or `.specify/pipeline/pipeline.md` when installed into a project.
2. Read `core/adapters.json` or `.specify/pipeline/adapters.json`.
3. Read `core/state-schema.json` or `.specify/pipeline/state-schema.json`.
4. Read `core/handoff.md` or `.specify/pipeline/handoff.md`.
5. Follow the shared pipeline instructions exactly.

If the shared core files are missing in a target project, ask the user to run `speckit-pipeline install --tool codex` from the `speckit-pipeline` repository.

Do not run `specify integration switch`.
Do not mutate `.specify/integration.json`.
