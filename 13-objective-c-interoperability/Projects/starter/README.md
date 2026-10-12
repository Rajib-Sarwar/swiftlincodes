# Legacy Notes Lab — starter

Open `LegacyNotesLab/LegacyNotesLab.xcodeproj` in Xcode 16+ and choose an iOS 17.6+ simulator. Swift 6 mode, no packages or network access. All changes are in memory and reset on launch.

Four TODOs in NotesAdapter.swift intentionally produce wrong behavior; the project builds but verification fails until completed.

Run `bash verify.sh` and `bash verify.sh release` on macOS with Xcode selected. These compile actual Objective-C and Swift, generate the Objective-C interface, call across both directions, and run 17 behavior checks. Checks use explicit failure counts, so they remain active in optimized builds. No simulator is needed for this boundary test. Temporary build/header artifacts are printed for inspection.

The UI is a thin main-actor owner of a synchronous in-memory adapter. It reloads snapshots after successful writes and preserves rows on failure. This is not disk persistence, networking, a thread-safe service, or a general migration framework. The typed NSArray copies its container, not its note objects.

Screenshot placeholder: capture the final list after Save, then blank-title failure with rows retained.
<!-- SCREENSHOT TODO: Add genuine simulator captures showing both language-call preview and failure state. -->
