---
name: commit
description: Creates commits following Conventional Commits with proper GPG signing, scope selection, and pre-commit validation. Works across any repository by discovering repo-specific configuration. Use when creating commits, writing commit messages, or when the user asks to commit changes.
---

# Universal Commit Skill

Guides committing changes following each project's Conventional Commits standard. Adapts to any repository by discovering its specific configuration.

## Critical Requirements

1. **Never commit directly to `main`** - Always check the current branch first. If on `main`, create a new branch before committing.
2. **Always run commits outside sandbox** - Use `required_permissions: ["all"]` for GPG signing and pre-commit hooks.
3. **Never use `--no-gpg-sign`** - All commits must be GPG-signed.
4. **Never use `--no-verify`** - Pre-commit hooks must always run.

## Discovering Repo Configuration

Before your first commit in a repository, discover its commit conventions:

### 1. Allowed Scopes and Types

Read the commitlint config file in the repo root. Common filenames:

- `commitlint.config.js`
- `commitlint.config.cjs`
- `commitlint.config.mjs`
- `commitlint.config.ts`
- `.commitlintrc.js` / `.commitlintrc.json` / `.commitlintrc.yml`

Look for `scope-enum` to find allowed scopes and `type-enum` to find allowed types. If `scope-empty` is set to `[2, 'never']`, a scope is **required**.

```bash
# Quick discovery
ls commitlint.config.* .commitlintrc* 2>/dev/null
```

### 2. Pre-commit and Pre-push Hooks

Check for hook configuration:

- `.husky/` directory for husky-managed hooks
- `lint-staged` config in `package.json` or `.lintstagedrc`
- `pre-commit` and `pre-push` scripts in `.husky/`

```bash
ls .husky/ 2>/dev/null
```

### 3. Changeset / Versioning

Check if the repo uses changesets for versioning:

```bash
ls .changeset/config.json 2>/dev/null
```

If changesets are used and your changes affect a published package, check if a changeset already covers your changes (`ls .changeset/*.md`). If not, remind the user to create one with `pnpm changeset` (or the repo's package manager equivalent).

### 4. Recent Commit Style

Review recent commits to match the repo's conventions:

```bash
git log --oneline -10
```

## Commit Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Rules

| Rule               | Requirement                                                          |
| ------------------ | -------------------------------------------------------------------- |
| Header max length  | 100 characters                                                       |
| Subject case       | lowercase (never sentence-case, start-case, pascal-case, upper-case) |
| Subject ending     | No period                                                            |
| Scope              | Check commitlint config — often **required**                         |
| Body line length   | Max 100 characters                                                   |
| Body leading blank | Required if body present                                             |

**Note**: These are the most common defaults from `@commitlint/config-conventional`. Always verify against the repo's actual commitlint config, as projects may override these.

## Standard Commit Types

These types are standard across Conventional Commits:

| Type       | Description                                             |
| ---------- | ------------------------------------------------------- |
| `feat`     | New feature                                             |
| `fix`      | Bug fix                                                 |
| `docs`     | Documentation only                                      |
| `style`    | Formatting, whitespace (no code change)                 |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf`     | Performance improvement                                 |
| `test`     | Adding or correcting tests                              |
| `build`    | Build system or external dependencies                   |
| `ci`       | CI configuration changes                                |
| `chore`    | Other changes (not src or test)                         |
| `revert`   | Reverts a previous commit                               |
| `wip`      | Work in progress (avoid if possible)                    |

Always confirm the repo's `type-enum` — some projects add or remove types.

## Commit Workflow

```bash
# 1. Check current branch — NEVER commit directly to main
git branch --show-current
# If on main, create and switch to a new branch:
#   git checkout -b fix/short-description
#   git checkout -b feat/short-description

# 2. Stage changes
git add <files>

# 3. Commit with HEREDOC (recommended for multi-line messages)
git commit -m "$(cat <<'EOF'
feat(scope): add new capability

Implements the feature with supporting details
about what was done and why.
EOF
)"

# Or simple one-liner
git commit -m "feat(scope): add new capability"
```

## Scope Selection

When choosing a scope:

1. **Read the commitlint config** to get the list of allowed scopes.
2. Pick the scope that best describes **where** the change lives:
   - If the change is in a specific package/app, use that package's scope.
   - If the change spans infrastructure (CI, config, deps), use the relevant infrastructure scope.
   - If multiple packages are affected, use the primary one or a broader scope if available.
3. If no existing scope fits and a new one is justified, mention it to the user — they may need to update the commitlint config.

## Breaking Changes

Indicate breaking changes with `!` after type/scope:

```bash
feat(scope)!: change public API interface
```

Or with a footer:

```
feat(scope): change public API interface

BREAKING CHANGE: Interface now requires new properties.
All consumers must update their usage.
```

## Handling Pre-commit Failures

| Failure Type           | Fix                                                                                    |
| ---------------------- | -------------------------------------------------------------------------------------- |
| Formatting/Linting     | Usually auto-fixed by hooks. Re-stage modified files and commit again.                 |
| Commit message invalid | Fix the message format (check scope, case, period, length) and retry.                  |
| Local tarball deps     | Switch from `file:` paths to registry versions before committing (check repo scripts). |
| GPG signing error      | Run `export GPG_TTY=$(tty)` and retry. Check `gpg --list-secret-keys`.                 |
| Sandbox permissions    | Re-run with `required_permissions: ["all"]`.                                           |

## Common Pitfalls

### Invalid Scope

**Symptom**: `scope-enum` error from commitlint.

**Fix**: Read the commitlint config to find allowed scopes. Use one of those.

### Subject Case Error

**Symptom**: `subject-case` error.

**Fix**: Use lowercase for the entire subject. `add new feature` not `Add new feature`.

### Missing Scope

**Symptom**: `scope-empty` error.

**Fix**: Always include a scope. Read the commitlint config for allowed values.

## Quick Reference

```bash
# Check you're NOT on main
git branch --show-current

# Create branch if on main
git checkout -b feat/my-feature

# Discover allowed scopes
cat commitlint.config.* 2>/dev/null | head -60

# Stage and commit
git add . && git commit -m "feat(scope): add feature"

# Validate commit format
echo "feat(scope): add feature" | npx commitlint

# View recent commits for style reference
git log --oneline -10

# Amend last commit (only if not pushed!)
git commit --amend

# Check for changesets
ls .changeset/*.md 2>/dev/null
```
