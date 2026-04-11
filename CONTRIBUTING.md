# Contributing

Thanks for contributing to `speckit-pipeline`.

## Scope

This repository is intentionally narrow. Keep contributions aligned with the project boundary:

- Improve the single-feature orchestration workflow
- Clarify stage behavior, gate handling, or reporting contracts
- Improve public-project packaging, documentation, and validation

Avoid changing the project into:

- a multi-feature scheduler
- a release manager
- a generic backlog planner
- a repo-wide automation framework

## Before Opening a PR

Check the following:

- `SKILL.md` still matches the repository purpose
- `references/gating-rules.md` stays consistent with `SKILL.md`
- `agents/openai.yaml` still describes the skill accurately
- documentation changes keep English and Chinese sections reasonably aligned

## Suggested Validation

At minimum:

- confirm required files still exist
- read `SKILL.md` for internal consistency
- read `references/gating-rules.md` for gate alignment

If you change the workflow semantics, explain:

- what changed
- why it changed
- which user requests should now trigger the new behavior
- whether the change affects blocking gates or completion criteria

## Pull Request Guidance

Prefer small, focused pull requests.

Good PRs for this repo usually do one of these:

- improve one stage rule
- tighten one gate definition
- improve documentation clarity
- improve packaging and validation for public reuse
