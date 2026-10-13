import Foundation

/// A nonempty, whitespace-trimmed identifier supplied by the caller.
/// Identity is case-sensitive. It is not a URL and is not globally generated here.
public struct SavedItemID: Hashable, Sendable {
    public let rawValue: String
    public init?(_ rawValue: String) {
        let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        // TODO 1: Reject a blank normalized identifier.
        self.rawValue = value
    }
}

/// A small in-memory collection of unique IDs in insertion order.
/// Copies are independent values. Persistence and synchronization belong to the caller.
public struct SavedItems: Sendable {
    public enum Insertion: Equatable, Sendable { case inserted, alreadySaved }
    public enum Failure: Error, Equatable, Sendable { case invalidCapacity, capacityReached }
    /// The maximum number of unique IDs, fixed at initialization.
    public let capacity: Int
    private var storage: [SavedItemID] = []
    /// IDs in insertion order. Modifying the returned array does not modify this value.
    public var ids: [SavedItemID] { storage }
    public var count: Int { storage.count }

    /// Creates an empty collection with a strictly positive capacity.
    /// - Throws: `Failure.invalidCapacity` for zero or a negative capacity.
    public init(capacity: Int = 20) throws {
        guard capacity > 0 else { throw Failure.invalidCapacity }
        self.capacity = capacity
    }
    /// Whether the ID is already saved. Complexity: O(n).
    public func contains(_ id: SavedItemID) -> Bool { storage.contains(id) }

    /// Inserts a new ID at the end, or reports an existing ID without moving it.
    ///
    /// Duplicate detection takes precedence over the capacity check. Failure leaves
    /// the collection unchanged. This operation does not write to disk or the network.
    /// - Returns: `.inserted` or `.alreadySaved`.
    /// - Throws: `Failure.capacityReached` for a new ID when full.
    /// - Complexity: O(n), including the duplicate scan; copies may add allocation cost.
    @discardableResult
    public mutating func insert(_ id: SavedItemID) throws -> Insertion {
        // TODO 2: Handle an existing ID before checking capacity.
        guard storage.count < capacity else { throw Failure.capacityReached }
        storage.append(id)
        return .inserted
    }
    /// Removes the matching ID and preserves the relative order of the others.
    /// - Returns: Whether an ID was removed. An absent ID is a no-op.
    /// - Complexity: O(n).
    @discardableResult
    public mutating func remove(_ id: SavedItemID) -> Bool {
        guard let index = storage.firstIndex(of: id) else { return false }
        // TODO 3: Remove the matching ID.
        _ = index
        return true
    }
    /// Compatibility spelling with identical behavior to `insert(_:)`.
    @available(*, deprecated, renamed: "insert(_:)")
    @discardableResult
    public mutating func add(_ id: SavedItemID) throws -> Insertion { try insert(id) }
}
