#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CLI="$ROOT/bin/speckit-pipeline"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT
PIPELINE_STAGES="specify clarify plan checklist tasks analyze implement converge"

fail() { echo "FAIL: $*" >&2; exit 1; }
assert_file() { [ -f "$1" ] || fail "expected file: $1"; }
assert_no_file() { [ ! -e "$1" ] || fail "expected no file: $1"; }
assert_contains() { grep -q "$2" "$1" || fail "expected $1 to contain $2"; }

make_project() {
  dir="$TMP_ROOT/$1"
  mkdir -p "$dir/.specify" "$dir/specs/001-demo"
  printf '{"feature":"001-demo"}\n' > "$dir/.specify/feature.json"
  printf '# Demo\n' > "$dir/specs/001-demo/spec.md"
  echo "$dir"
}

add_codex_artifacts() {
  p="$1"
  for s in $PIPELINE_STAGES; do
    mkdir -p "$p/.agents/skills/speckit-$s"
    printf -- '---\nname: speckit-%s\n---\n' "$s" > "$p/.agents/skills/speckit-$s/SKILL.md"
  done
}

add_qoder_artifacts() {
  p="$1"
  mkdir -p "$p/.qoder/commands"
  for s in $PIPELINE_STAGES; do
    printf -- '---\ndescription: speckit %s\n---\n' "$s" > "$p/.qoder/commands/speckit.$s.md"
  done
}

p="$(make_project codex)"
add_codex_artifacts "$p"
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
assert_file "$p/.agents/skills/speckit-pipeline/SKILL.md"
assert_file "$p/.specify/pipeline/pipeline.md"
assert_contains "$p/.specify/pipeline/config.json" '"version": "0.3.0"'
"$CLI" doctor --project "$p" >/tmp/speckit-test.out

p="$(make_project qoder)"
add_qoder_artifacts "$p"
"$CLI" install --tool qoder --project "$p" >/tmp/speckit-test.out
assert_file "$p/.qoder/skills/speckit-pipeline/SKILL.md"
assert_file "$p/.specify/pipeline/adapters.json"
"$CLI" doctor --project "$p" >/tmp/speckit-test.out

p="$(make_project all)"
add_codex_artifacts "$p"
add_qoder_artifacts "$p"
for t in claude cursor; do
  for s in $PIPELINE_STAGES; do
    mkdir -p "$p/.$t/skills/speckit-$s"
    printf -- '---\nname: speckit-%s\n---\n' "$s" > "$p/.$t/skills/speckit-$s/SKILL.md"
  done
done
"$CLI" install --tool all --project "$p" >/tmp/speckit-test.out
assert_file "$p/.agents/skills/speckit-pipeline/SKILL.md"
assert_file "$p/.claude/skills/speckit-pipeline/SKILL.md"
assert_file "$p/.qoder/skills/speckit-pipeline/SKILL.md"
assert_file "$p/.cursor/skills/speckit-pipeline/SKILL.md"
"$CLI" doctor --project "$p" >/tmp/speckit-test.out

p="$TMP_ROOT/missing-specify"
mkdir -p "$p"
if "$CLI" doctor --project "$p" >/tmp/speckit-test.out 2>&1; then
  fail "doctor should fail without .specify"
fi
assert_contains /tmp/speckit-test.out "missing: .specify"

p="$(make_project missing-artifacts)"
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
if "$CLI" doctor --project "$p" >/tmp/speckit-test.out 2>&1; then
  fail "doctor should fail without stage artifacts"
fi
assert_contains /tmp/speckit-test.out "missing: codex stage artifact"

p="$(make_project missing-optional-stages)"
for s in specify plan tasks analyze implement converge; do
  mkdir -p "$p/.agents/skills/speckit-$s"
  printf -- '---\nname: speckit-%s\n---\n' "$s" > "$p/.agents/skills/speckit-$s/SKILL.md"
done
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
if "$CLI" doctor --project "$p" >/tmp/speckit-test.out 2>&1; then
  fail "doctor should fail without clarify and checklist artifacts"
fi
assert_contains /tmp/speckit-test.out "missing: codex stage artifact .agents/skills/speckit-clarify/SKILL.md"
assert_contains /tmp/speckit-test.out "missing: codex stage artifact .agents/skills/speckit-checklist/SKILL.md"

p="$(make_project missing-converge)"
for s in specify clarify plan checklist tasks analyze implement; do
  mkdir -p "$p/.agents/skills/speckit-$s"
  printf -- '---\nname: speckit-%s\n---\n' "$s" > "$p/.agents/skills/speckit-$s/SKILL.md"
done
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
if "$CLI" doctor --project "$p" >/tmp/speckit-test.out 2>&1; then
  fail "doctor should fail without converge artifact"
fi
assert_contains /tmp/speckit-test.out "missing: codex stage artifact .agents/skills/speckit-converge/SKILL.md"

p="$(make_project conflict)"
add_codex_artifacts "$p"
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
printf 'local edit\n' >> "$p/.agents/skills/speckit-pipeline/SKILL.md"
"$CLI" install --tool codex --project "$p" >/tmp/speckit-test.out
assert_file "$p/.agents/skills/speckit-pipeline/SKILL.md.new"
"$CLI" install --tool codex --project "$p" --force >/tmp/speckit-test.out
assert_no_file "$p/.agents/skills/speckit-pipeline/SKILL.md.new"

p="$(make_project uninstall)"
add_qoder_artifacts "$p"
mkdir -p "$p/specs/001-demo"
printf '{}\n' > "$p/specs/001-demo/.speckit-pipeline-state.json"
printf 'log\n' > "$p/specs/001-demo/.speckit-pipeline-log.md"
"$CLI" install --tool qoder --project "$p" >/tmp/speckit-test.out
"$CLI" uninstall --tool qoder --project "$p" >/tmp/speckit-test.out
assert_no_file "$p/.qoder/skills/speckit-pipeline/SKILL.md"
assert_file "$p/specs/001-demo/.speckit-pipeline-state.json"
assert_file "$p/specs/001-demo/.speckit-pipeline-log.md"

"$CLI" --help >/tmp/speckit-test.out
assert_contains /tmp/speckit-test.out "speckit-pipeline 0.3.0"

p="$TMP_ROOT/piped-install"
mkdir -p "$p/bin" "$p/fakebin"
printf '#!/usr/bin/env bash\necho FAKE_LOCAL "$@"\n' > "$p/bin/speckit-pipeline"
chmod +x "$p/bin/speckit-pipeline"
printf '#!/usr/bin/env bash\necho FAKE_CURL\nexit 42\n' > "$p/fakebin/curl"
chmod +x "$p/fakebin/curl"
if (cd "$p" && PATH="$p/fakebin:$PATH" bash -s -- --tool codex --project "$p" < "$ROOT/install.sh") >/tmp/speckit-test.out 2>&1; then
  fail "piped install should not complete with fake curl"
fi
assert_contains /tmp/speckit-test.out "FAKE_CURL"
if grep -q "FAKE_LOCAL" /tmp/speckit-test.out; then
  fail "piped install should not execute cwd bin/speckit-pipeline"
fi

echo "All tests passed"
