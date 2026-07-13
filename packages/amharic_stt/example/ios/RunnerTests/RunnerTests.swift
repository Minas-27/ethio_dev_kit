import Flutter
import UIKit
import XCTest

@testable import amharic_stt

// The iOS side of amharic_stt wraps SFSpeechRecognizer. Its meaningful
// behaviour (authorization, locale support, real transcription) only exercises
// on a device with speech assets and a user speaking, so it is verified
// manually — see the package README "Verification status".
//
// This test just asserts `isAvailable` answers with a bool and never leaves the
// result block uncalled, keeping the Swift sources compilable in CI.
class RunnerTests: XCTestCase {

  func testIsAvailableReturnsBool() {
    let plugin = AmharicSttPlugin()
    let call = FlutterMethodCall(methodName: "isAvailable", arguments: nil)

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue(result is Bool)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
}
