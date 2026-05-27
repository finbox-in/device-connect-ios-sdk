//
//  RiskManagerTests.swift
//  RiskManagerTests
//
//  Created by Ashutosh Jena on 06/06/24.
//

import XCTest
@testable import RiskManager

final class RiskManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        FinBox.syncQueueOverride = nil
    }

    func testCreateUserReturnsQuicklyFromMainThread() {
        var enqueuedWorkCount = 0
        FinBox.syncQueueOverride = { _ in
            enqueuedWorkCount += 1
        }

        assertReturnsQuicklyFromMainThread {
            FinBox.createUser(apiKey: "api-key", customerId: "customer-id", success: { _ in }, error: { _ in })
        }

        XCTAssertEqual(enqueuedWorkCount, 1)
    }

    func testStartPeriodicSyncReturnsQuicklyFromMainThread() {
        var enqueuedWorkCount = 0
        FinBox.syncQueueOverride = { _ in
            enqueuedWorkCount += 1
        }

        assertReturnsQuicklyFromMainThread {
            FinBox().startPeriodicSync()
        }

        XCTAssertEqual(enqueuedWorkCount, 1)
    }

    func testSyncOnceReturnsQuicklyFromMainThread() {
        var enqueuedWorkCount = 0
        FinBox.syncQueueOverride = { _ in
            enqueuedWorkCount += 1
        }

        assertReturnsQuicklyFromMainThread {
            FinBox().syncOnce()
        }

        XCTAssertEqual(enqueuedWorkCount, 1)
    }

    private func assertReturnsQuicklyFromMainThread(_ operation: @escaping () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let expectation = expectation(description: "operation returned from main thread")

        DispatchQueue.main.async {
            XCTAssertTrue(Thread.isMainThread, file: file, line: line)
            let start = DispatchTime.now()
            operation()
            let end = DispatchTime.now()
            let elapsed = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000

            XCTAssertLessThan(elapsed, 0.05, file: file, line: line)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

}
