# Reference API review

## Consumer and call sites
A SwiftUI screen owns a small, ordered list of saved catalog IDs. It calls `try saved.insert(id)`, handles `.alreadySaved` without moving the row, and calls `saved.remove(id)` without knowing the storage layout.

## Invariants and failure
SavedItemID trims surrounding whitespace, rejects blank input, and preserves case. SavedItems has a fixed positive capacity. It accepts each ID once, in insertion order. The duplicate check precedes capacity because a no-op needs no additional slot. New insertion at capacity throws without changing state. An absent removal returns false. These choices let the UI explain the outcome without reconstructing library rules.

## Surface and ownership
The struct, ID, nested outcomes/errors, initializer, and consumer operations are public. Storage is private; snapshots are getter-only values. Ordinary-import tests and the separate app target check public usability. Copying SavedItems creates independent value behavior, and editing the returned array does not mutate the collection. Sendable permits value transfer; it does not make concurrent mutation of one variable safe.

## Cost and deliberate omissions
Duplicate scans and removal are O(n). Array storage is enough for a small list; a larger workload could justify a separate membership index while preserving observable order. This package does not persist data or call a server. It does not claim that IDs are globally unique or refer to existing content.

We do not make IDs literal-expressible because their construction can fail. We do not dynamically forward storage properties because that enlarges the interface and could bypass invariants. We do not clamp capacity because changing a caller's requested limit silently would be surprising. The separate exercise wrapper clamps only a display preference with an explicit diagnostic.

## Compatible migration
The old `add(_:)` spelling remains a forwarding alias with an identical signature and behavior. The deprecation annotation explains the replacement; it does not perform forwarding. For a hypothetical established 1.x package, this compatible transition is a minor release; later removal needs a major release plan. Test clients may treat warnings as errors, so explain the new warning in release notes. No real release version is asserted or tagged in this teaching project.

## Screenshot placeholder
<!-- SCREENSHOT TODO: Xcode Quick Help for insert(_:), showing duplicate and capacity rules at an app call site. -->
> Add a genuine Quick Help capture; do not substitute a fabricated IDE screenshot.
