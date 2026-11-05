.PHONY: setup migrate build test lint ci-lint

setup:
	brew bundle
	prek install
migrate:
	swift Migrate.swift
build:
	swift build
test:
	swift test
lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --fix
ci-lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --strict
