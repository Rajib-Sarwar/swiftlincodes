import Foundation
import os
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

func baselineCounts(_ tags: [Int]) -> [Int] {
    tags.map { tag in tags.reduce(0) { $0 + ($1 == tag ? 1 : 0) } }
}
func candidateCounts(_ tags: [Int]) -> [Int] {
    // TODO 1: Count each tag once, then restore source order. Preserve baseline output.
    return baselineCounts(tags)
}
func milliseconds(_ duration: Duration) -> Double {
    let c = duration.components
    return Double(c.seconds) * 1_000 + Double(c.attoseconds) / 1_000_000_000_000 // TODO 2: Correct the fractional milliseconds divisor.
}
func median(_ samples: [Double]) -> Double? {
    guard !samples.isEmpty, samples.allSatisfy({ $0.isFinite && $0 >= 0 }) else { return nil }
    let sorted = samples.sorted(), middle = sorted.count / 2
    return sorted.count.isMultiple(of: 2) ? sorted[middle - 1] / 2 + sorted[middle] / 2 : sorted[middle]
}
struct RunReport {
    let samples: [Double]
    let checksum: Int
    var medianMilliseconds: Double { median(samples) ?? 0 }
}
// A complete synchronous operation is the interval; inputs are prepared by the caller.
func measureCounts(_ tags: [Int], candidate: Bool, repeats: Int = 5) -> RunReport {
    let signposter = OSSignposter(subsystem: "com.swiftlin.CatalogPerformanceLab", category: "Catalog")
    let clock = ContinuousClock()
    var samples: [Double] = [], checksum = 0
    for _ in 0..<max(0, repeats) {
        let state = signposter.beginInterval("BuildCounts", id: signposter.makeSignpostID(), "candidate=\(candidate)")
        // Each interval has a unique ID and ends even if this scope later gains an early return.
        let elapsed: Duration
        do {
            defer { signposter.endInterval("BuildCounts", state) }
            let start = clock.now
            let output = candidate ? candidateCounts(tags) : baselineCounts(tags)
            checksum = output.reduce(0, +) // Consume output identically in both variants.
            elapsed = start.duration(to: clock.now)
        }
        samples.append(milliseconds(elapsed))
    }
    return RunReport(samples: samples, checksum: checksum)
}

final class PreviewSession {
    var onRefresh: (() -> Void)?
    private(set) var refreshes = 0
    func installCallback() {
        // TODO 3: Preserve refresh behavior without retaining the session through its own callback.
        onRefresh = { self.refreshes += 1 }
    }
}

enum ImageFailure: Error { case invalidSize, invalidData, generationFailed }
func decodePreview(_ data: Data, maxPixelSize: Int) throws -> CGImage {
    guard maxPixelSize > 0 else { throw ImageFailure.invalidSize }
    guard let source = CGImageSourceCreateWithData(data as CFData,
        [kCGImageSourceShouldCache: false] as CFDictionary) else { throw ImageFailure.invalidData }
    // TODO 4: Downsample at decode time to maxPixelSize with ImageIO; do not decode full size.
    guard let image = CGImageSourceCreateImageAtIndex(source, 0,
        [kCGImageSourceShouldCacheImmediately: true] as CFDictionary)
    else { throw ImageFailure.invalidData }
    return image
}
// A synthetic JPEG generated before profiling decode. No copyrighted or remote assets.
func makeImageFixture(width: Int = 2048, height: Int = 1536) throws -> Data {
    guard width > 0, height > 0, width <= 4096, height <= 4096 else { throw ImageFailure.invalidSize }
    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
        bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { throw ImageFailure.generationFailed }
    context.setFillColor(CGColor(red: 0.12, green: 0.2, blue: 0.4, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    for i in 0..<12 {
        context.setFillColor(CGColor(red: CGFloat(i) / 12, green: 0.6, blue: 0.35, alpha: 1))
        context.fillEllipse(in: CGRect(x: i * width / 14, y: i * height / 16, width: width / 4, height: height / 4))
    }
    guard let image = context.makeImage() else { throw ImageFailure.generationFailed }
    let data = NSMutableData()
    guard let destination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil)
    else { throw ImageFailure.generationFailed }
    CGImageDestinationAddImage(destination, image, [kCGImageDestinationLossyCompressionQuality: 0.85] as CFDictionary)
    guard CGImageDestinationFinalize(destination) else { throw ImageFailure.generationFailed }
    return data as Data
}
