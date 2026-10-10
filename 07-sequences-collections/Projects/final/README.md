# Offline Library — final

Open `OfflineLibrary/OfflineLibrary.xcodeproj` in Xcode 27 or newer. Choose an iOS simulator. The supplied SwiftUI interface uses local video fixtures; there is no network or third-party dependency.

The final implements all three helpers. All five model tests pass.

## Milestones
1. Implement ChunkRanges.Iterator.next(). Keep iteration state independent and remain exhausted after nil.
2. Implement batches(_:size:) over Collection indices, including nonzero slice indices and String.Index. Invalid sizes throw.
3. Implement firstReadyTitles(_:limit:) with one pass and an immediate stop after enough matches. A nonpositive limit consumes nothing.
4. Run `swift test` from this directory. It tests the actual app model, including a one-shot source and Unicode boundaries.
5. In the simulator, change batch size, navigate, toggle downloaded status, save a snapshot, edit, and restore it. Compare exact titles, batch contents, and generated chunk plans.

The UI materializes slices as arrays at its ownership boundary. It uses tiny fixtures and recomputes groups for clarity; measure and cache derived data appropriately for large production libraries. Snapshot independence assumes the value-type Video model; an array does not deep-copy class instances.

<!-- SCREENSHOT TODO: Capture the first library batch and Ready to watch section, then a saved snapshot after toggling a video's download state. -->
> Screenshot placeholder: genuine simulator captures will be inserted here.
