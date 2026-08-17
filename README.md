# swift-package-template ![](https://github.com/ahcode0919/swift-package-template/actions/workflows/swift.yml/badge.svg?branch=main)

Baseline template for Swift packages

Package description here

## Commands

- Build project - `swift build`
- Run unit tests: `swift test`
- Run formatting/linting: `swift package plugin swiftlint --fix`

Project supports a `Makefile`

- Build - `make build`
- Test - `make test`
- Lint - `make lint`

## Supports

- Github Actions
  - Build
  - Unit test
  - Verify `CHANGELOG.md`

## Setup Steps

- Update Badge URL for new repository location
- Update `Sources` and `Tests` directory names
- Update `Package.swift` target names to match new directory names
- Add application and test files
- Update `CHANGELOG.md`
- Update this `README.md` file
