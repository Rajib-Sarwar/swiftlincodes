# Packet Lab — final

Open `PacketLab/PacketLab.xcodeproj`, choose PacketLab and an iOS simulator. Requires Xcode with Swift 6 and iOS 17.6+ SDK support. No signing team or external dependencies.

The final implements bounds-checked borrowed decoding, an independent safe reference, encoding, and nine contract tests.

## Format
A5 magic, version 01, two-byte little-endian sample count, that many UInt16 little-endian samples, then a modulo-256 sum of all preceding bytes. Empty samples are allowed. Reject truncation, extra bytes, invalid header and checksum. This is a teaching packet format, not a BLE standard; no hardware or streaming transport is included.

## Milestones
1. Implement readLE16 with checked offsets and loadUnaligned.
2. Implement checksum8 using defined wrapping arithmetic.
3. Borrow Data bytes within a closure and return owned samples.
4. Compare against decodePacketReference, run `swift test`, then `swift test -c release`. Optionally enable Address Sanitizer in the Xcode scheme. No test should intentionally execute undefined behavior.

Test valid input, all malformed fixtures, edit bytes, and round-trip the result. Failure retains the previous sample list. The UI previews only the first 50 samples. No performance improvement is claimed; benchmark representative inputs before choosing this over the safe implementation.

## Screenshot placeholder
<!-- SCREENSHOT TODO: Capture valid samples [4660, 255, 256], then Bad checksum with the same retained samples. -->
[Actual simulator walkthrough captures will be added here.]
