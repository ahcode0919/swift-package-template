// swift-tools-version:6.1

import Foundation
import PackageDescription

let skipPlugins: Bool = ProcessInfo.processInfo.environment["SKIP_PLUGINS"] != nil

let package = Package(
    name: "swift-package-template",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftPackageTemplate",
            targets: ["SwiftPackageTemplate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.3")
    ],
    targets: [
        .target(
            name: "SwiftPackageTemplate",
            dependencies: [],
            plugins: skipPlugins ? [] : [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SwiftPackageTemplateTests",
            dependencies: ["SwiftPackageTemplate"],
            plugins: skipPlugins ? [] : [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
    ]
)
