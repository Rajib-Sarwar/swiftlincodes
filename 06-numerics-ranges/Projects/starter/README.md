# Offline Download Lab — starter

Open `OfflineDownloadLab/OfflineDownloadLab.xcodeproj` in Xcode 27 or newer and select an iOS simulator. No account, networking, or package dependency is needed. The app transfers simulated chunks with a button.

The starter builds, but its three TODO helpers return nil. Tests intentionally fail until you implement them.

## Milestones
1. Implement progress: validate counts, return nil for unknown/invalid totals, convert before division.
2. Implement exact nonnegative Double-to-Int conversion. Reject fractional and nonfinite inputs.
3. Implement nextChunk using remaining length before addition. Never duplicate or omit a byte.
4. Run `swift test` from this directory. The package tests the same model source used by the app.
5. Run the app: transfer a 1000-byte file in 256-byte chunks, reset, try 1024, then an empty file and an unknown total. Explain the final chunk and the progress policy.

The project uses Int for in-memory simulation offsets, not a universal wire format. A real downloader needs cancellation, persistence, transport error handling, and a server contract; those belong to later chapters.

<!-- SCREENSHOT TODO: Capture the simulator after transferring 768 of 1000 bytes, then the final 768..<1000 chunk. -->
> Screenshot placeholder: progress, byte counts, and final short chunk will appear here after a genuine simulator capture.
