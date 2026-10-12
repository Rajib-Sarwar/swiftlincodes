# Live Search Lab — final

Requires macOS, Swift 6+, and Xcode 16+ (iOS 17.6+ simulator). Combine is an Apple framework; this project does not compile in Swiftlin's Linux browser runner.

Open `LiveSearchLab/LiveSearchLab.xcodeproj`. Run on a simulator without a signing team. The app uses delayed local fixtures, not a network service.

Final implements normalization, immediate cancellation, request-local recovery, and one coherent view state.

1. Normalize text before suppressing consecutive duplicates.
2. Short queries emit idle, cancelling old work rather than being filtered out.
3. Select the latest inner publisher; cancellation must happen before its quiet timer expires.
4. Convert request errors into failed state inside the inner request, never a fake empty success.

Try `sw`, wait for Loading, then enter `swift`. Enter `error`, then `swift`. Clear the field while loading. Empty results for `none` must differ from failure. Equivalent normalized input is deduplicated; to retry the same failed query, clear and retype. A dedicated retry action is a future extension.

From this directory run `swift test` and `swift test -c release`. Twelve deterministic Combine tests inject manually controlled gates and subjects; no sleeps or internet are needed. The tests cover the orchestration contract. Check the 300 ms main-queue quiet interval and screen state manually in the simulator.

Input, gate and service callbacks must be serialized. Production uses the main queue. The injected service contract is one result or error, never an empty completion. The demo fulfills it. Real HTTP services must validate status codes and decode failures. Cancellation does not undo remote side effects.

<!-- SCREENSHOT TODO: Capture final Live Search Lab showing Swift results, then Error failure followed by successful recovery. -->
Screenshot placeholder: genuine simulator captures to follow.
