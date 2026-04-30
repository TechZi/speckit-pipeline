# speckit-pipeline

English | [中文](#中文说明)

`speckit-pipeline` runs one concrete feature through the Spec Kit workflow in a disciplined, gated order. Starting with v0.2.0, it can be installed into projects for Codex, Claude Code, Qoder, and Cursor so teams can switch tools without losing workflow state.

It does not replace official Spec Kit commands or skills. It coordinates them and records progress in repository files.

## What It Does

- Runs one feature through `specify`, `clarify`, `plan`, `tasks`, `analyze`, `checklist`, and `implement`
- Supports Codex, Claude Code, Qoder, and Cursor wrappers
- Distinguishes a new feature request from resuming an interrupted feature
- Stores handoff state in `specs/<feature>/.speckit-pipeline-state.json`
- Treats artifact consistency and verification as real gates
- Avoids `specify integration switch` so multiple tools can share one project safely

## Install

v0.2.0 uses POSIX shell scripts and supports macOS/Linux.

From a checkout of this repository:

```bash
./bin/speckit-pipeline install --tool codex --project /path/to/project
./bin/speckit-pipeline install --tool qoder --project /path/to/project
./bin/speckit-pipeline install --tool all --project /path/to/project
```

From GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/TechZi/speckit-pipeline/main/install.sh | bash -s -- --tool all --project /path/to/project
```

To install from a specific branch or tag, set `SPECKIT_PIPELINE_REF`:

```bash
curl -fsSL https://raw.githubusercontent.com/TechZi/speckit-pipeline/main/install.sh | SPECKIT_PIPELINE_REF=v0.2.0 bash -s -- --tool codex --project /path/to/project
```

`--project` defaults to the current directory.

## Tool Invocation

After installation, invoke the wrapper supported by your current AI coding tool:

```text
Codex:  $speckit-pipeline <request>
Claude: /speckit-pipeline <request>
Qoder:  /speckit-pipeline <request>
Cursor: /speckit-pipeline <request>
```

## New vs Resume

The pipeline starts a new feature when the user provides a concrete new feature request or explicitly says to start/create/build/implement a new feature.

The pipeline resumes when the user asks to continue/resume/接着/继续/恢复 or when no new feature request is present and an incomplete feature state exists.

If an incomplete feature exists and the user input also looks like a new request, the pipeline pauses and asks whether to resume the existing feature or start a new one.

## CLI

```bash
bin/speckit-pipeline install --tool <codex|claude|qoder|cursor|all> [--project DIR] [--force]
bin/speckit-pipeline doctor [--project DIR]
bin/speckit-pipeline upgrade [--project DIR] [--force]
bin/speckit-pipeline uninstall --tool <codex|claude|qoder|cursor> [--project DIR]
```

Command behavior:

- `install` copies shared core files and the selected wrapper
- `doctor` verifies `.specify`, shared pipeline files, installed wrappers, and official stage artifacts
- `upgrade` refreshes shared core files and already installed wrappers
- `uninstall` removes only the selected wrapper

Safety rules:

- Existing modified files are not overwritten by default
- Conflicts are written to `<file>.new`
- `--force` overwrites wrappers and shared core files
- Feature state and log files are never deleted
- The installer never runs `specify integration switch`
- The installer never mutates `.specify/integration.json`

## Installed Layout

```text
.specify/pipeline/
  pipeline.md
  adapters.json
  state-schema.json
  handoff.md
  config.json

.agents/skills/speckit-pipeline/SKILL.md
.claude/skills/speckit-pipeline/SKILL.md
.qoder/skills/speckit-pipeline/SKILL.md
.cursor/skills/speckit-pipeline/SKILL.md
```

Single-tool users can install only the wrapper they need. Multi-tool users can install `--tool all` and switch between tools using the same feature-local state.

## Doctor

Run:

```bash
bin/speckit-pipeline doctor --project /path/to/project
```

`doctor` checks for `.specify`, shared pipeline files, installed wrappers, and the official Spec Kit stage artifacts for installed tools. It checks `specify`, `clarify`, `plan`, `tasks`, `analyze`, `checklist`, and `implement`.

## Upgrade

Run:

```bash
bin/speckit-pipeline upgrade --project /path/to/project
```

`upgrade` refreshes `.specify/pipeline/*` and any already installed tool wrappers. It does not install new wrappers unless they already exist in the project. Use `--force` to overwrite local edits.

## Uninstall

Run:

```bash
bin/speckit-pipeline uninstall --tool qoder --project /path/to/project
```

`uninstall` removes only the selected wrapper. It keeps shared pipeline files, feature state files, and feature log files.

## Repository Layout

- `SKILL.md`: Codex environment-level wrapper
- `core/`: shared pipeline instructions and schemas
- `templates/`: tool-specific wrappers
- `bin/speckit-pipeline`: shell installer/doctor CLI
- `install.sh`: GitHub bootstrap installer
- `references/gating-rules.md`: gate definitions and completion criteria
- `test/run-tests.sh`: shell integration tests

## License

This project is licensed under the Apache License 2.0. See `LICENSE`.

## 中文说明

`speckit-pipeline` 用来把一个具体功能按照 Spec Kit 的标准流程串起来执行。v0.2.0 开始，它支持安装到 Codex、Claude Code、Qoder、Cursor 四种工具中，让你在 token 用完或会话中断后切换工具继续工作。

它不替代官方 Spec Kit commands 或 skills，而是协调它们，并把进度写入仓库文件。

### 安装

v0.2.0 使用 POSIX shell，支持 macOS/Linux。

```bash
./bin/speckit-pipeline install --tool all --project /path/to/project
```

或者只安装单个工具：

```bash
./bin/speckit-pipeline install --tool qoder --project /path/to/project
```

从 GitHub 安装：

```bash
curl -fsSL https://raw.githubusercontent.com/TechZi/speckit-pipeline/main/install.sh | bash -s -- --tool all --project /path/to/project
```

### 调用方式

```text
Codex:  $speckit-pipeline <需求>
Claude: /speckit-pipeline <需求>
Qoder:  /speckit-pipeline <需求>
Cursor: /speckit-pipeline <需求>
```

### 新需求与恢复

如果输入是一个新的明确需求，pipeline 会创建并推进新 feature。

如果用户说“继续 / 恢复 / resume”，或者当前 feature 有未完成 state 且用户没有提供新需求，pipeline 会从上次阶段继续。

如果既存在未完成 feature，用户输入又像新需求，pipeline 必须暂停并询问是继续旧 feature 还是启动新 feature。

### 安全规则

- 默认不覆盖用户改过的文件
- 冲突写入 `<file>.new`
- `--force` 才覆盖 wrapper/core
- 不删除 feature state/log
- 不执行 `specify integration switch`
- 不修改 `.specify/integration.json`

### 诊断、升级与卸载

```bash
bin/speckit-pipeline doctor --project /path/to/project
bin/speckit-pipeline upgrade --project /path/to/project
bin/speckit-pipeline uninstall --tool qoder --project /path/to/project
```

`doctor` 会检查 `.specify`、共享 pipeline 文件、已安装 wrapper，以及 `specify`、`clarify`、`plan`、`tasks`、`analyze`、`checklist`、`implement` 官方阶段产物。

`upgrade` 只刷新共享 core 和已经安装的 wrapper；`uninstall` 只移除指定工具的 wrapper，不删除 feature state/log。
