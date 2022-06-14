import XCTest
import SnapshotTesting
@testable import HSERickApp

class HomeScreenSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()

//        isRecording = true
    }

    func testThatHomeScreenIsCorrect() {
        let vc = HomeBuilder.build()
        assertSnapshot(matching: vc, as: .image)
      }
}
