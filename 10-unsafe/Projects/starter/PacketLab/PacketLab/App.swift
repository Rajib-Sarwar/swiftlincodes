import SwiftUI

@main struct PacketLabApp: App {
    var body: some Scene { WindowGroup { PacketLabView() } }
}
struct PacketLabView: View {
    @State private var fixture = PacketFixture.valid
    @State private var input = hex(PacketFixture.valid.bytes)
    @State private var packet: SensorPacket?
    @State private var message = "Decode the fixture, then try a malformed packet."
    var body: some View {
        NavigationStack {
            List {
                Section("Packet contract") {
                    Text("A5 · version 01 · UInt16 count (little-endian) · UInt16 samples · wrapping byte checksum")
                        .font(.callout)
                    Text("One complete packet. No trailing bytes. This is a teaching format, not a Bluetooth standard.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Section("1 · Choose or edit bytes") {
                    Picker("Fixture", selection: $fixture) {
                        ForEach(PacketFixture.allCases) { Text($0.rawValue).tag($0) }
                    }.onChange(of: fixture) { _, value in input = hex(value.bytes) }
                    TextEditor(text: $input).font(.system(.body, design: .monospaced)).frame(minHeight: 100)
                        .accessibilityLabel("Packet hex bytes")
                    Button("Decode packet") {
                        do {
                            let data = try parseHex(input)
                            let candidate = try decodePacket(data)
                            let reference = try decodePacketReference(data)
                            guard candidate == reference else { message = "Decoder differs from the reference. Library unchanged."; return }
                            packet = candidate
                            message = "Decoded \(candidate.samples.count) samples. Matches the safe reference."
                        } catch { message = packetMessage(error) }
                    }
                }
                Section("2 · Owned result") {
                    if let packet {
                        Text("\(packet.samples.count) samples — valid beyond the buffer closure")
                        ForEach(Array(packet.samples.prefix(50).enumerated()), id: \.offset) { index, sample in
                            HStack { Text("Sample \(index + 1)"); Spacer(); Text("\(sample)").monospacedDigit() }
                        }
                        if packet.samples.count > 50 { Text("Showing the first 50 samples.") }
                        Button("Encode result back to bytes") {
                            do { input = hex(try encodePacket(packet)); message = "Encoded the owned samples using the explicit wire format." }
                            catch { message = packetMessage(error) }
                        }
                    } else { Text("No valid result yet.").foregroundStyle(.secondary) }
                }
                Section("Result") { Text(message) }
                Section("What this demonstrates") {
                    Text("The pointer is borrowed only during decoding. No raw memory escapes, no packet is loaded as a Swift struct, and failed decoding preserves the last valid result.")
                    Text("The baseline copies Data to an array. The borrowed version avoids that explicit copy, but no performance advantage is claimed without measurement.").font(.caption).foregroundStyle(.secondary)
                }
            }.navigationTitle("Packet Lab")
        }
    }
}
