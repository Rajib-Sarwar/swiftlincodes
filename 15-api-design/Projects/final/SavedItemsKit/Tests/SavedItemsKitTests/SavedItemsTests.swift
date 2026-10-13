import XCTest
import SavedItemsKit

final class SavedItemsTests: XCTestCase {
    func id(_ value: String) -> SavedItemID { SavedItemID(value)! }
    func testIdentifierTrimsWhitespace() { XCTAssertEqual(id("  A\n").rawValue, "A") }
    func testIdentifierRejectsBlank() { XCTAssertNil(SavedItemID(" \n")); XCTAssertNil(SavedItemID("")) }
    func testIdentifierIsCaseSensitive() { XCTAssertNotEqual(id("A"), id("a")) }
    func testCapacityMustBePositive() {
        for value in [0, -1] {
            XCTAssertThrowsError(try SavedItems(capacity: value)) { XCTAssertEqual($0 as? SavedItems.Failure, .invalidCapacity) }
        }
    }
    func testInsertionPreservesOrder() throws {
        var items = try SavedItems(); XCTAssertEqual(try items.insert(id("B")), .inserted)
        try items.insert(id("A")); XCTAssertEqual(items.ids.map(\.rawValue), ["B", "A"])
    }
    func testDuplicateWhenFullIsNoOp() throws {
        var items = try SavedItems(capacity: 1); try items.insert(id("A"))
        XCTAssertEqual(try items.insert(id("A")), .alreadySaved); XCTAssertEqual(items.count, 1)
    }
    func testCapacityFailureIsAtomic() throws {
        var items = try SavedItems(capacity: 1); try items.insert(id("A"))
        XCTAssertThrowsError(try items.insert(id("B"))) { XCTAssertEqual($0 as? SavedItems.Failure, .capacityReached) }
        XCTAssertEqual(items.ids, [id("A")])
    }
    func testRemovalPreservesOrderAndReportsAbsence() throws {
        var items = try SavedItems(); for s in ["A", "B", "C"] { try items.insert(id(s)) }
        XCTAssertTrue(items.remove(id("B"))); XCTAssertFalse(items.remove(id("B")))
        XCTAssertEqual(items.ids, [id("A"), id("C")])
    }
    func testRemovalReleasesCapacity() throws {
        var items = try SavedItems(capacity: 1); try items.insert(id("A")); items.remove(id("A"))
        XCTAssertEqual(try items.insert(id("B")), .inserted)
    }
    func testCopiesAreIndependent() throws {
        var original = try SavedItems(); try original.insert(id("A")); var copy = original
        try copy.insert(id("B")); XCTAssertEqual(original.count, 1); XCTAssertEqual(copy.count, 2)
    }
    func testSnapshotDoesNotMutateCollection() throws {
        var items = try SavedItems(); try items.insert(id("A")); var snapshot = items.ids
        snapshot.removeAll(); XCTAssertEqual(items.count, 1)
    }
    func testDeprecatedSpellingForwardsWithoutBehaviorChange() throws {
        var items = try SavedItems(capacity: 1)
        XCTAssertEqual(try items.add(id("A")), .inserted)
        XCTAssertEqual(try items.add(id("A")), .alreadySaved)
        XCTAssertThrowsError(try items.add(id("B")))
    }
}
