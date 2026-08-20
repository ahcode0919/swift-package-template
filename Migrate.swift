import Foundation

// Read project files

let readme = URL(fileURLWithPath: "README.md")
let swiftAction = URL(fileURLWithPath: ".github/workflows/swift.yml")
let sourcesDir = URL(fileURLWithPath: "Sources/SwiftPackageTemplate")
let testsDir = URL(fileURLWithPath: "Tests/SwiftPackageTemplateTests")

class Package {
    enum PackageError: Error {
        case libraryNameNotFound
        case sourcePackageNotFound
        case testPackageNotFound
    }

    private let packageUrl = URL(fileURLWithPath: "Package.swift")
    private var package: SPMPackage?

    private func getPackage() throws -> SPMPackage {
        if let package {
            return package
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "package", "describe", "--type", "json"]
        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let package = try JSONDecoder().decode(SPMPackage.self, from: data)
        self.package = package
        return package
    }

    func getProject() throws -> Project {
        let spmPackage = try self.getPackage()
        guard let libraryName = spmPackage.products.first?.name else {
            throw PackageError.libraryNameNotFound
        }
        guard let sourceTarget = spmPackage.targets.first(where: { $0.path.contains("Sources") }) else {
            throw PackageError.sourcePackageNotFound
        }
        guard let testTarget = spmPackage.targets.first(where: { $0.path.contains("Tests") }) else {
            throw PackageError.testPackageNotFound
        }
        let project = Project(
            projectName: spmPackage.name,
            packageSwift: packageUrl,
            libraryName: libraryName,
            sourceTarget: sourceTarget.name,
            testTarget: testTarget.name,
            sourcePath: URL(filePath: sourceTarget.path),
            testPath: URL(filePath: testTarget.path),
            readmeHeader: spmPackage.name
        )
        return project
    }
}

struct Project {
    let projectName: String
    let packageSwift: URL
    let libraryName: String
    let sourceTarget: String
    let testTarget: String
    let sourcePath: URL
    let testPath: URL
    let readmeHeader: String
}

struct SPMPackage: Codable {
    let name: String
    let products: [Product]
    let targets: [Target]

    struct Product: Codable {
        let name: String
    }

    struct Target: Codable {
        let name: String
        let path: String
    }
}

enum FileUpdater {
    static func findAndReplace(in url: URL, find: String, replaceWith: String) throws {
        let contents = try String(contentsOf: url, encoding: .utf8)
        let updated = contents.replacingOccurrences(of: find, with: replaceWith)
        try updated.write(to: url, atomically: true, encoding: .utf8)
    }

    static func moveDirectory(old oldDirectory: URL, new newDirectory: URL) throws {
        let fileManager = FileManager.default
        try fileManager.moveItem(at: oldDirectory, to: newDirectory)
    }

    static func delete(file url: URL) throws {
        let fileManager = FileManager.default
        try fileManager.removeItem(at: url)
    }

    static func removeFirstLines(from url: URL, count: Int) throws {
        let contents = try String(contentsOf: url, encoding: .utf8)
        let lines = contents.split(separator: "\n", omittingEmptySubsequences: false)
        let remaining = lines.dropFirst(count).joined(separator: "\n")
        try remaining.write(to: url, atomically: true, encoding: .utf8)
    }

    static func renameFile(from url: URL, to newUrl: URL) throws {
        let fileManager = FileManager.default
        try fileManager.moveItem(at: url, to: newUrl)
    }
}

enum MigrationError: Error {
    case invalidProjectNames
}

// Read current project values
let package = Package()
let project = try package.getProject()

print("Project Name: \(project.projectName)")
print("Library Name: \(project.libraryName)")
print("Target Name: \(project.sourceTarget)")
print("Sources Path: \(project.sourcePath.absoluteString)")
print("Test Target Name: \(project.testTarget)")
print("Tests Path: \(project.testPath.absoluteString)")

// Read new values
print("Enter new project name (lower-kebab-case)")
let newProjectName = readLine()

print("Enter new library name (PascalCasedName)")
let newLibraryName = readLine()

guard let projectName = newProjectName, let libraryName = newLibraryName else {
    print("Project and Library names not populated")
    throw MigrationError.invalidProjectNames
}

// Update Package.swift
try FileUpdater.findAndReplace(in: project.packageSwift, find: project.projectName, replaceWith: projectName)
try FileUpdater.findAndReplace(in: project.packageSwift, find: project.libraryName, replaceWith: libraryName)

// Update README.md
try FileUpdater.findAndReplace(in: readme, find: project.projectName, replaceWith: projectName)

// Update swift.yml
try FileUpdater.findAndReplace(in: swiftAction, find: project.projectName, replaceWith: projectName)

// Update directories
let newSourcesDir = URL(fileURLWithPath: "Sources/\(libraryName)")
let newTestsDir = URL(fileURLWithPath: "Tests/\(libraryName)Tests")
try FileUpdater.moveDirectory(old: project.sourcePath, new: newSourcesDir)
try FileUpdater.moveDirectory(old: project.testPath, new: newTestsDir)

// Update files
let exampleSourceFile = URL(fileURLWithPath: "Sources/\(libraryName)/SwiftPackageTemplate.swift")
let exampleTestFile = URL(fileURLWithPath: "Tests/\(libraryName)Tests/SwiftPackageTemplateTests.swift")
let newExampleSourceFile = URL(fileURLWithPath: "Sources/\(libraryName)/\(libraryName).swift")
let newExampleTestFile = URL(fileURLWithPath: "Tests/\(libraryName)Tests/\(libraryName)Tests.swift")
try FileUpdater.renameFile(from: exampleSourceFile, to: newExampleSourceFile)
try FileUpdater.renameFile(from: exampleTestFile, to: newExampleTestFile)

// Update code names
try FileUpdater.findAndReplace(in: newExampleSourceFile, find: project.libraryName, replaceWith: libraryName)
try FileUpdater.findAndReplace(in: newExampleTestFile, find: project.libraryName, replaceWith: libraryName)

// Remove command from Makefile
try FileUpdater.removeFirstLines(from: URL(fileURLWithPath: "Makefile"), count: 2)

// Remove script
try FileUpdater.delete(file: URL(fileURLWithPath: "Migrate.swift"))
