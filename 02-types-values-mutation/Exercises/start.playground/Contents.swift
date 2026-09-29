import Foundation

// Swiftlin — Types, Values & Mutation
// Starter Exercises
//
// The supporting types for these exercises are available in:
// Sources/ChapterTypes.swift
//
// Try each challenge before comparing your work with final.playground.

// MARK: - Exercise 1: Deterministic Color Palette

// Generate five random Color values using SeededGenerator
// with a seed of 4321.
//
// Then generate another palette using the same seed.
// Verify that both palettes are identical.

// Your solution here.


// MARK: - Exercise 2: Brightness Classification

let colors = [
    Color(red: 0.1, green: 0.1, blue: 0.2),
    Color(red: 0.5, green: 0.6, blue: 0.5),
    Color(red: 0.9, green: 0.8, blue: 1.0),
    Color(red: 0.2, green: 0.3, blue: 0.2),
    Color(red: 0.7, green: 0.7, blue: 0.7)
]

// Classify each color using Brightness.
//
// Determine how many colors are:
// - .dark
// - .medium
// - .light

// Your solution here.


// MARK: - Exercise 3: Valid Hex Colors

// Open Sources/ChapterTypes.swift and improve HexColor so that it accepts
// only values in the #RRGGBB format.
//
// The six characters after "#" must be hexadecimal digits:
// 0-9, A-F, or a-f.
//
// These examples describe the expected behavior:

let validUppercase = HexColor(rawValue: "#FF5733") // valid
let validMixedCase = HexColor(rawValue: "#00ffAA") // valid

let invalidCharacters = HexColor(rawValue: "#GG0000") // should be nil
let missingHash = HexColor(rawValue: "FF5733")        // should be nil
let tooShort = HexColor(rawValue: "#FFF")             // should be nil
