# Catalog Performance Lab — starter

Open `CatalogPerformanceLab/CatalogPerformanceLab.xcodeproj` in Xcode 16+ using an iOS 17.6+ simulator or your own device signing. Swift 6, no packages or network. Use Product → Profile with an optimized Release configuration to collect representative traces.

Four TODOs in PerformanceCore.swift intentionally retain repeated scans, use a wrong fractional time unit, retain a callback cycle, and decode a full image. It builds; several correctness tests are expected to fail until fixed.

Run `swift test` and `swift test -c release` from this directory on macOS. Twelve tests verify results, units, lifetime, and image bounds. They do not assert wall-clock speedups or prove total memory savings. Record those on your target device in `PROFILE-REPORT.md`.

CPU input generation is outside the measured interval. Both modes include output checksum consumption and use five samples. The buttons deliberately run synchronously to make main-thread work visible; they are teaching controls, not a production scheduling pattern. Alternate run order, separate cold/warm results, and record raw samples.

Prepare JPEG before recording Decode. Image bytesPerRow × height is row storage, not total process footprint. Release the preview to compare live allocations. For lifetime, Open → Close; inspect PreviewSession in Memory Graph. Clean up experiment breaks the starter cycle before repeating.

Signpost subsystem: `com.swiftlin.CatalogPerformanceLab`, category: `Catalog`, interval: `BuildCounts`. Use Points of Interest or the signpost instrument available in your Xcode version. No user content is logged.

Screenshot placeholder: selected BuildCounts interval + main-thread call tree; separate image and lifetime evidence.
<!-- SCREENSHOT TODO: Add actual Instruments and Memory Graph captures with device, build mode, and selected interval. Do not invent before/after metrics. -->
