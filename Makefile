.PHONY: setup build test format ci-format lint ci-lint gitleaks zizmor

migrate:
	swift Migrate.swift
setup:
	brew bundle
	prek install
build:
	swift build
test:
	swift test
format:
	swift format --in-place --recursive --parallel .
ci-format:
	swift format lint --strict --recursive --parallel .
lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --fix
ci-lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --strict
gitleaks:
	gitleaks git --redact --verbose
zizmor:
	zizmor .
