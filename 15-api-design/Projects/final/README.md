# Saved Items Lab — final

Requires Xcode 16+ / Swift 6 and iOS 17.6+ simulator. No dependencies are downloaded.
Open `SavedItemsLab/SavedItemsLab.xcodeproj`, choose SavedItemsLab and an iPhone simulator, then Run. The app imports the sibling local Swift package SavedItemsKit. Keep both folders together.

Run library checks from `SavedItemsKit`: `swift test`. Tests use ordinary `import SavedItemsKit`, not `@testable`, so they also check the consumer-facing API.

The final implements all contracts and passes the twelve tests. Compare behavior and reasoning, not only line-by-line code.

## Walkthrough
1. Read call sites in App.swift before library internals. Write duplicate, full-list, order and absence policies in API-REVIEW.md.
2. Save A, B, C; save A again. It should report already saved without changing order.
3. Attempt a fourth new ID. It should report full and preserve the first three.
4. Remove B, save the fourth ID. Order should be A, C, fourth.
5. Run tests; inspect public initializers and read-only snapshots from the separate consumer module.
6. Read the deprecated `add` forwarding method. Tests intentionally produce deprecation warnings to prove old source still compiles.

This lab uses a small linear array deliberately. Operations are O(n), copying may allocate, data does not persist, and Sendable values do not make unsynchronized shared mutation safe. No networking, account, or production storage is implied.

## Screenshot placeholder
> Capture the simulator after the full-list attempt, showing three saved items and the actionable error.
<!-- SCREENSHOT TODO: SavedItemsLab, final variant, three saved rows and capacity error, no personal data. -->
