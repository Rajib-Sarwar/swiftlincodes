enum DownloadMath {
    static func progress(completed: Int, total: Int?) -> Double? {
        // TODO: Validate, then divide.
        return nil
    }
}
print(DownloadMath.progress(completed: 250, total: 1000) ?? -1)
print(DownloadMath.progress(completed: 0, total: nil) ?? -1)
print(DownloadMath.progress(completed: 1001, total: 1000) ?? -1)
