import Foundation

public struct Color: Equatable {
    public var red: Double
    public var green: Double
    public var blue: Double

    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state = 6364136223846793005 &* state &+ 1442695040888963407
        return state
    }
}

public extension Color {
    static func random(using generator: inout SeededGenerator) -> Self {
        Self(
            red: Double.random(in: 0...1, using: &generator),
            green: Double.random(in: 0...1, using: &generator),
            blue: Double.random(in: 0...1, using: &generator)
        )
    }
}

public enum Brightness: CaseIterable, Hashable {
    case dark
    case medium
    case light

    public init?(_ color: Color) {
        guard
            (0...1).contains(color.red),
            (0...1).contains(color.green),
            (0...1).contains(color.blue)
        else {
            return nil
        }

        let average = (color.red + color.green + color.blue) / 3

        switch average {
        case ..<0.33:
            self = .dark
        case ..<0.67:
            self = .medium
        default:
            self = .light
        }
    }
}

public struct HexColor: RawRepresentable {
    public let rawValue: String

    public init?(rawValue: String) {
        let hexadecimalCharacters =
            CharacterSet(charactersIn: "0123456789ABCDEFabcdef")

        guard
            rawValue.count == 7,
            rawValue.first == "#",
            rawValue
                .dropFirst()
                .unicodeScalars
                .allSatisfy(hexadecimalCharacters.contains)
        else {
            return nil
        }

        self.rawValue = rawValue
    }
}
