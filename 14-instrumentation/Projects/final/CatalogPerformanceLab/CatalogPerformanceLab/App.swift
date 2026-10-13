import SwiftUI
import Combine

@MainActor
final class LabModel: ObservableObject {
    @Published var report = "Run the same fixture in both modes. No results have been measured yet."
    @Published var imageReport = "Prepare the JPEG before recording a decode interval."
    @Published var image: CGImage?
    @Published var lifetimeReport = "No session opened."
    private let tags = (0..<4000).map { $0 % 64 }
    private var fixture: Data?
    private var session: PreviewSession?
    private weak var observedSession: PreviewSession?
    func run(candidate: Bool) {
        // Deliberately synchronous for comparing main-thread work. Not a production UI pattern.
        let result = measureCounts(tags, candidate: candidate)
        report = "\(candidate ? "Candidate" : "Baseline"): median \(String(format: "%.3f", result.medianMilliseconds)) ms; checksum \(result.checksum). Samples: \(result.samples.map { String(format: "%.3f", $0) }.joined(separator: ", "))."
    }
    func prepare() {
        do { fixture = try makeImageFixture(); imageReport = "JPEG ready. Now record decode, excluding fixture creation." }
        catch { imageReport = "Fixture failed: \(error)" }
    }
    func decode() {
        guard let fixture else { imageReport = "Prepare the fixture first."; return }
        do {
            image = try decodePreview(fixture, maxPixelSize: 384)
            if let image {
                imageReport = "\(image.width) × \(image.height) pixels; \(image.bytesPerRow * image.height) bytes of row storage. This is not total process memory."
            }
        } catch { imageReport = "Decode failed: \(error)" }
    }
    func releaseImage() { image = nil; imageReport = "Preview released. Compare live allocations after repeated decode/release cycles." }
    func openSession() {
        cleanup()
        let value = PreviewSession(); value.installCallback()
        session = value; observedSession = value
        lifetimeReport = "One owner holds the session. Close it, then inspect lifetime."
    }
    func closeSession() {
        session = nil
        lifetimeReport = observedSession == nil ? "Session released." : "Session still alive. Inspect the callback capture."
    }
    func cleanup() {
        // Allows the deliberately broken starter to release its cycle between experiments.
        observedSession?.onRefresh = nil; session = nil
        lifetimeReport = "Experiment cleaned up."
    }
}
@main
struct CatalogPerformanceApp: App {
    @StateObject private var model = LabModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("1. CPU experiment") {
                        Text("4,000 fixed tags • 5 samples per run. Baseline may briefly block this learning app.")
                        Button("Run baseline") { model.run(candidate: false) }
                        Button("Run candidate") { model.run(candidate: true) }
                        Text(model.report).font(.caption).textSelection(.enabled)
                    }
                    Section("2. Decoded image memory") {
                        Button("Prepare JPEG fixture") { model.prepare() }
                        Button("Decode preview") { model.decode() }
                        Button("Release preview") { model.releaseImage() }
                        if let image = model.image {
                            Image(decorative: image, scale: 3).resizable().scaledToFit().frame(height: 128)
                        }
                        Text(model.imageReport).font(.caption)
                    }
                    Section("3. Lifetime experiment") {
                        Button("Open session") { model.openSession() }
                        Button("Close session") { model.closeSession() }
                        Button("Clean up experiment") { model.cleanup() }
                        Text(model.lifetimeReport).font(.caption)
                    }
                }.navigationTitle("Catalog Performance Lab")
            }
        }
    }
}
