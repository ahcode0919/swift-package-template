import Testing

@testable import SwiftPackageTemplate

@Suite struct SwiftPackageTemplateTests {
    @Test func defaultText() {
        #expect(SwiftPackageTemplate().text == "Hello, World!")
    }
}
