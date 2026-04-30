---
name: speckit-pipeline
description: Run one Spec Kit feature through a gated, cross-tool pipeline that can resume across Codex, Claude Code, Qoder, and Cursor.
---

# Speckit Pipeline

You are running the cross-tool Spec Kit Pipeline with adapter: codex.

Before doing any feature work:

1. Read `.specify/pipeline/pipeline.md`.
2. Read `.specify/pipeline/adapters.json`.
3. Read `.specify/pipeline/state-schema.json`.
4. Read `.specify/pipeline/handoff.md`.
5. Follow the shared pipeline instructions exactly.

If the shared core files are missing, stop and ask the user to run `speckit-pipeline install --tool codex` in the project.

Do not run `specify integration switch`.
Do not mutate `.specify/integration.json`.
