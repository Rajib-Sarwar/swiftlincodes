enum DownloadMath {
    static func byteCount(from value: Double) -> Int? {
        // TODO: Convert exactly and reject negative counts.
        return nil
    }
}
for value in [1024.0, 1.5, -1.0, Double.infinity, Double.nan] {
    print(DownloadMath.byteCount(from: value).map(String.init) ?? "invalid")
}
