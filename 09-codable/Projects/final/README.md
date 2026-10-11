# Library Sync — final

Open `LibrarySync/LibrarySync.xcodeproj`, choose LibrarySync and an iOS simulator, then Run. Requires Xcode with Swift 6 and iOS 17.6+ SDK support. No signing team, API keys, or packages are included.

This is a focused continuation of Offline Library: the same stable-ID video concept gains an API DTO and a versioned cache. Search and playback UI are intentionally outside this lab. Fixture imports are local, not HTTP requests. Small teaching payloads and file operations are synchronous.

All decoding, validation, migration, and persistence milestones are implemented. The final includes eight contract tests.

## Milestones
1. Define missing tags vs null policy in VideoDTO.
2. Configure date decoding, map DTOs, and validate IDs/titles/duplicates before replacing state.
3. Support cache versions 1 and 2, reject future versions, and use the supplied atomic disk writer.
4. Import valid data, try every broken fixture, save, relaunch and restore, migrate v1 then save v2.

Run `swift test` from this directory. Compare typed errors and state preservation, not localized error prose. Version 1 guarantees ready videos; this is why the migration supplies that status. Unknown API status strings are retained and shown as unsupported.

## Screenshot placeholder
<!-- SCREENSHOT TODO: Capture the simulator after a valid import, expand Last saved JSON, then capture a rejected duration showing the previous library still present. -->
[Walkthrough screenshots will be added after a genuine simulator capture.]
