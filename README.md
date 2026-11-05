# swift-package-template ![](https://github.com/ahcode0919/swift-package-template/actions/workflows/swift.yml/badge.svg?branch=main)

Baseline template for Swift packages

Package description here

To run migration script and rename all project values run: `make migrate`

## Commands

- Build project - `swift build`
- Run unit tests: `swift test`
- Run formatting/linting: `swift package plugin swiftlint --fix`

Project supports a `Makefile`

- Build - `make build`
- Test - `make test`
- Lint (auto-fix) - `make lint`
- Lint (strict, same as CI) - `make ci-lint`

## Supports

- Github Actions
  - Build
  - Unit test
  - Code coverage threshold
  - Lint
- Release Drafter
  - Drafts the next GitHub Release as pull requests merge into `main`
  - Auto-labels pull requests from branch name, title and changed files
- Pull request template

## Setup Steps

- Update Badge URL for new repository location
- Update `Sources` and `Tests` directory names
- Update `Package.swift` target names to match new directory names
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
