.PHONY: setup build test lint ci-lint gitleaks zizmor

migrate:
	swift Migrate.swift
setup:
	brew bundle
	prek install
build:
	swift build
test:
	swift test
lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --fix
ci-lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --strict
gitleaks:
	gitleaks git --redact --verbose
zizmor:
	zizmor .
