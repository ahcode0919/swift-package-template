build:
	swift build
test:
	swift test
lint:
	swift package plugin --allow-writing-to-package-directory swiftlint --fix