# Inbox Lab — starter

Open `InboxLab/InboxLab.xcodeproj` with Xcode 16 or newer. Choose an iOS simulator (iOS 17.6+) and Run. No signing team is needed for simulator builds. The pure Swift core can be tested from this directory with `swift test` (Swift 6+).

The starter builds, but its four TODOs deliberately give incomplete filtering, ordering and summaries. Behavioral tests are expected to fail until you finish them.

1. Return a rule from `makeRule` using the three options.
2. Implement a strict comparator: priority descending, ID ascending.
3. Filter and sort in `visibleNotices` without mutating input.
4. Aggregate visible rows using `reduce(into:)` in `categoryCounts`.

Default output: IDs 4, 1, 3; work 2, social 1. With Work selected: IDs 1, 3. With unread disabled: IDs 4, 1, 3, 2. Priority 3: ID 4. The supplied importer accepts four rows and reports rejected ID 5 rather than silently dropping it.

Fixtures have unique IDs and priorities in 0...3. No push notification permission, network service, persistence, authentication or analytics is implemented. This is a synchronous data-transformation feature; it does not teach concurrent map.

## Verify

```sh
swift test
swift test -c release
xcodebuild -project InboxLab/InboxLab.xcodeproj -scheme InboxLab -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

## Screenshot to add

<!-- SCREENSHOT TODO: Capture the final Inbox Lab default screen with three rows and category counts; then capture Work + minimum priority 3 showing an empty state. -->
Screenshot placeholder: default inbox and filtered empty state. Do not substitute a mockup for a verified simulator capture.
