@propertyWrapper
struct PreviewCount {
    private var storage: Int
    private let range: ClosedRange<Int>
    private(set) var projectedValue: Bool
    var wrappedValue: Int {
        get { storage }
        set {
            storage = min(max(newValue, range.lowerBound), range.upperBound)
            projectedValue = storage != newValue
        }
    }
    init(wrappedValue: Int, _ range: ClosedRange<Int>) {
        self.range = range
        storage = min(max(wrappedValue, range.lowerBound), range.upperBound)
        projectedValue = storage != wrappedValue
    }
}
struct Preferences { @PreviewCount(1...10) var visibleCount = 20 }
var settings = Preferences()
print(settings.visibleCount, settings.$visibleCount)
settings.visibleCount = -2
print(settings.visibleCount, settings.$visibleCount)
settings.visibleCount = 6
print(settings.visibleCount, settings.$visibleCount)
