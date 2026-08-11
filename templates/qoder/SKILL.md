---
name: speckit-pipeline
description: Run or resume one Spec Kit feature through a gated, cross-tool workflow with planning, implementation, verification, and convergence across Codex, Claude Code, Qoder, and Cursor. Use when a user wants end-to-end feature delivery, planning-only execution, or continuation of an interrupted Spec Kit feature.
---

# Speckit Pipeline

You are running the cross-tool Spec Kit Pipeline with adapter: qoder.

Before doing any feature work:

1. Read `.specify/pipeline/pipeline.md`.
2. Read `.specify/pipeline/adapters.json`.
3. Read `.specify/pipeline/state-schema.json`.
4. Read `.specify/pipeline/handoff.md`.
5. Follow the shared pipeline instructions exactly.

If the shared core files are missing, stop and ask the user to run `speckit-pipeline install --tool qoder` in the project.

Do not run `specify integration switch`.
Do not mutate `.specify/integration.json`.
