# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and repository releases follow Semantic Versioning.

## [0.2.0] - Unreleased

### Added

- Cross-tool wrappers for Codex, Claude Code, Qoder, and Cursor
- Shared pipeline core under `core/`
- Shell installer CLI at `bin/speckit-pipeline`
- `install`, `doctor`, `upgrade`, and `uninstall` commands
- Feature-local state model for cross-tool handoff
- Shell integration tests for installer safety behavior

### Changed

- `SKILL.md` is now a thin Codex wrapper that delegates to the shared pipeline core
- README now documents single-tool and multi-tool installation flows
- GitHub Actions validation now checks shared core files, templates, JSON metadata, CLI help, and shell tests

### Fixed

- `doctor` now checks `clarify` and `checklist` stage artifacts in addition to the required implementation stages
- Piped GitHub installs no longer execute an unrelated `bin/speckit-pipeline` from the caller's current directory

## [0.1.0] - 2026-04-11

### Added

- Initial public repository packaging for the `speckit-pipeline` Codex skill
- Bilingual `README.md`
- `CONTRIBUTING.md`
- Lightweight GitHub Actions validation workflow
- `.gitignore` entry for macOS Finder artifacts

### Existing Core Assets

- `SKILL.md` for the single-feature Spec Kit orchestration workflow
- `agents/openai.yaml` for Codex UI metadata
- `references/gating-rules.md` for blocking and completion rules
