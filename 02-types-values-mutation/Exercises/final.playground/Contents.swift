import Foundation

// Swiftlin — Types, Values & Mutation
// Final Exercise Solutions

// MARK: - Exercise 1: Deterministic Color Palette

func makePalette(seed: UInt64, count: Int = 5) -> [Color] {
    var generator = SeededGenerator(seed: seed)

    return (0..<count).map { _ in
        Color.random(using: &generator)
    }
}

let firstPalette = makePalette(seed: 4321)
let secondPalette = makePalette(seed: 4321)

print(firstPalette == secondPalette) // true


// MARK: - Exercise 2: Brightness Classification

let colors = [
    Color(red: 0.1, green: 0.1, blue: 0.2),
    Color(red: 0.5, green: 0.6, blue: 0.5),
    Color(red: 0.9, green: 0.8, blue: 1.0),
    Color(red: 0.2, green: 0.3, blue: 0.2),
    Color(red: 0.7, green: 0.7, blue: 0.7)
]

let brightnessCounts = colors.reduce(into: [Brightness: Int]()) { counts, color in
    guard let brightness = Brightness(color) else {
        return
    }

    counts[brightness, default: 0] += 1
}

for brightness in Brightness.allCases {
    print("\(brightness): \(brightnessCounts[brightness, default: 0])")
}

// dark: 2
// medium: 1
// light: 2


// MARK: - Exercise 3: Valid Hex Colors

let validUppercase = HexColor(rawValue: "#FF5733")
let validMixedCase = HexColor(rawValue: "#00ffAA")

let invalidCharacters = HexColor(rawValue: "#GG0000")
let missingHash = HexColor(rawValue: "FF5733")
let tooShort = HexColor(rawValue: "#FFF")

print(validUppercase != nil)   // true
print(validMixedCase != nil)   // true
print(invalidCharacters == nil) // true
print(missingHash == nil)       // true
print(tooShort == nil)          // true
