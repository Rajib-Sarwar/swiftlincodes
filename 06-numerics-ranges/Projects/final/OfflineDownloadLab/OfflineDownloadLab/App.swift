import SwiftUI

@main
struct OfflineDownloadLabApp: App {
    var body: some Scene { WindowGroup { DownloadView() } }
}

struct DownloadView: View {
    @State private var total = 1000
    @State private var completed = 0
    @State private var size = 256
    @State private var unknown = false
    @State private var measurement = "1024"
    @State private var lastChunk = "No chunks transferred"
    var body: some View {
        NavigationStack {
            Form {
                Section("Offline video · simulated transfer") {
                    if let ratio = DownloadMath.progress(completed: completed, total: unknown ? nil : total) {
                        ProgressView(value: ratio)
                        Text(ratio, format: .percent.precision(.fractionLength(1)))
                    } else {
                        Text("Progress unavailable").foregroundStyle(.secondary)
                    }
                    Text("\(completed) / \(unknown ? "unknown" : String(total)) bytes")
                    Toggle("Unknown total", isOn: $unknown)
                    Picker("File size", selection: $total) {
                        Text("Empty (0)").tag(0)
                        Text("Exact multiple (1024)").tag(1024)
                        Text("Remainder (1000)").tag(1000)
                    }.onChange(of: total) { _, _ in reset() }
                    Picker("Chunk size", selection: $size) {
                        Text("128 bytes").tag(128)
                        Text("256 bytes").tag(256)
                    }
                    Button("Transfer next chunk") {
                        if let chunk = DownloadMath.nextChunk(from: completed, total: total, size: size) {
                            completed = chunk.upperBound
                            lastChunk = "\(chunk.lowerBound)..<\(chunk.upperBound) · \(chunk.count) bytes"
                        }
                    }.disabled(unknown || completed >= total)
                    Text(lastChunk).font(.system(.caption, design: .monospaced))
                    Button("Reset simulation", action: reset)
                }
                Section("Validate a measurement") {
                    TextField("Whole byte count", text: $measurement)
                    if let value = Double(measurement), let count = DownloadMath.byteCount(from: value) {
                        Text("Accepted: \(count) bytes")
                    } else { Text("Invalid byte count").foregroundStyle(.red) }
                    Text("Try 1024, 1.5, -1, or inf. This models a Double boundary; real integer metadata should be decoded as an integer.").font(.caption)
                }
                Section("Observe and explain") {
                    Text("Why is the last chunk shorter? Why does an unknown total hide the percentage? Formatting may round the display; the model keeps its byte count.")
                }
            }.navigationTitle("Download Lab")
        }
    }
    private func reset() { completed = 0; lastChunk = "No chunks transferred" }
}
