# swift-package-template ![](https://github.com/ahcode0919/swift-package-template/actions/workflows/swift.yml/badge.svg?branch=main)

Baseline template for Swift packages

Package description here

## Commands

Project supports a `Makefile`

- Setup (installs [Homebrew](https://brew.sh) tools from `Brewfile` and git hooks) - `make setup`
- Build - `make build`
- Test - `make test`
- Format ([swift-format](https://github.com/swiftlang/swift-format), config in `.swift-format`) - `make format`
- Check formatting (strict, same as CI) - `make ci-format`
- Lint (auto-fix) - `make lint`
- Lint (strict, same as CI) - `make ci-lint`
- Scan git history for secrets ([gitleaks](https://github.com/gitleaks/gitleaks)) - `make gitleaks`
- Audit GitHub Actions workflows ([zizmor](https://docs.zizmor.sh)) - `make zizmor`

## Supports

- Github Actions
  - Build
  - Unit test
  - Code coverage threshold
  - Format check (swift-format)
  - Lint
  - prek hooks
  - Secret scanning (gitleaks)
  - Workflow security audit (zizmor)
- Release Drafter
  - Drafts the next GitHub Release as pull requests merge into `main`
  - Auto-labels pull requests from branch name, title and changed files
- Dependabot
  - Weekly updates for GitHub Actions (grouped, SHA pins) and Swift packages
  - 7 day cooldown before adopting new releases
- Pull request template
- [prek](https://github.com/j178/prek) git hooks (`prek.toml`)
  - Whitespace, end-of-file, YAML, merge conflict and large file checks
  - swift-format and SwiftLint (strict) on commits that change Swift files
  - gitleaks on staged changes
  - zizmor on commits that change workflows

## Setup Steps

- Run `make migrate` to rename the project, library, targets, directories and example files (the script and its `Makefile` target remove themselves when done)
- Update the badge URL owner for the new repository location
- Run `make setup` to install tools and git hooks
- Add application and test files
- Update this `README.md` file

## Releases

Release notes are drafted automatically by [Release Drafter](https://github.com/release-drafter/release-drafter) as pull requests merge into `main`. To publish a release, review the draft on the GitHub Releases page and click **Publish**.

The next version is calculated from pull request labels:

| Label | Release notes section | Version bump |
| --- | --- | --- |
| `breaking-change` | Breaking Changes | major |
| `enhancement` | New Features | minor |
| `bug` | Bug Fixes | patch |
| `dependencies` | Dependencies | patch |
| `ignore-for-release` | Excluded | none |

Labels are applied automatically from the branch name (`feature/...`, `fix/...`, `docs/...`) or a conventional PR title (`feat:`, `fix:`, `feat!:`), and can be set manually.
