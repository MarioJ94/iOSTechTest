//
//  CacheTests.swift
//  TechTestTests
//
//  Created by Mario on 09/11/2026.
//

import XCTest

@testable import TechTest

final class CacheTests: XCTestCase {
    func testCacheStoresData() async {
        let sut = Cache<Int, String>(maxAge: 5, maxEntries: 2)
        let prevValue = await sut.get(key: 1)
        XCTAssertNil(prevValue)
        await sut.set(key: 1, value: "model")
        let newValue = await sut.get(key: 1)
        XCTAssertEqual(newValue, "model")
    }

    func testCacheRemoveCachedDataByKey() async {
        let sut = Cache<Int, String>(maxAge: 5, maxEntries: 2)
        await sut.set(key: 1, value: "model")
        let newValue = await sut.get(key: 1)
        XCTAssertEqual(newValue, "model")
        await sut.remove(key: 1)
        let erasedValue = await sut.get(key: 1)
        XCTAssertNil(erasedValue)
    }

    func testCacheClearsData() async {
        let sut = Cache<Int, String>(maxAge: 5, maxEntries: 2)
        await sut.set(key: 1, value: "model")
        let newValue = await sut.get(key: 1)
        XCTAssertEqual(newValue, "model")
        await sut.clear()
        let erasedValue = await sut.get(key: 1)
        XCTAssertNil(erasedValue)
    }
    
    func testCacheCleansUpExpiredDataOnMaxEntriesOverload() async throws {
        let sut = Cache<Int, String>(maxAge: 6, maxEntries: 4)
        await sut.set(key: 1, value: "model1")
        await sut.set(key: 2, value: "model2")
        try await Task.sleep(for: .seconds(4))
        await sut.set(key: 3, value: "model3")
        await sut.set(key: 4, value: "model4")
        let one = await sut.get(key: 1)
        let two = await sut.get(key: 2)
        let three = await sut.get(key: 3)
        let four = await sut.get(key: 4)
        let five = await sut.get(key: 5)
        XCTAssertNotNil(one)
        XCTAssertNotNil(two)
        XCTAssertNotNil(three)
        XCTAssertNotNil(four)
        XCTAssertNil(five)
        try await Task.sleep(for: .seconds(2.25))
        await sut.set(key: 5, value: "model5")
        let newOne = await sut.get(key: 1)
        let newTwo = await sut.get(key: 2)
        let newThree = await sut.get(key: 3)
        let newFour = await sut.get(key: 4)
        let newFive = await sut.get(key: 5)
        XCTAssertNil(newOne)
        XCTAssertNil(newTwo)
        XCTAssertNotNil(newThree)
        XCTAssertNotNil(newFour)
        XCTAssertNotNil(newFive)
    }
}
