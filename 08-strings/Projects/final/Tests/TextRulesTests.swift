import Foundation
import Testing
@testable import LibraryText

@Test func previewBoundaries() {
    #expect(titlePreview("Swift", limit: 4) == "Swi…")
    #expect(titlePreview("👨‍👩‍👧‍👦abc", limit: 3) == "👨‍👩‍👧‍👦a…")
    #expect(titlePreview("e\u{301}x", limit: 2) == "éx")
    #expect(titlePreview("a", limit: 1) == "a")
    #expect(titlePreview("ab", limit: 1) == "…")
    #expect(titlePreview("", limit: 4).isEmpty)
    #expect(titlePreview("abc", limit: 0).isEmpty)
    #expect(titlePreview("abc", limit: -1).isEmpty)
}
@Test func palindromeContract() {
    for text in ["", "a", "abba", "aba", "a a", "👩🏽‍💻a👩🏽‍💻", "ée\u{301}"] { #expect(isExactPalindrome(text)) }
    for text in ["Aa", "ab", "abca", "a!a?"] { #expect(!isExactPalindrome(text)) }
}
@Test func uniqueOrderAndEquivalence() {
    #expect(firstUniqueCharacter("swiss") == "w")
    #expect(firstUniqueCharacter("") == nil)
    #expect(firstUniqueCharacter("aabb") == nil)
    #expect(firstUniqueCharacter("ée\u{301}x") == "x")
    #expect(firstUniqueCharacter("👩🏽‍💻a👩🏽‍💻b") == "a")
}
@Test func titleValidation() {
    #expect(validateTitle("   \n") == .empty)
    #expect(validateTitle(String(repeating: "a", count: 30)) == nil)
    #expect(validateTitle(String(repeating: "a", count: 31)) == .characterLimit)
    #expect(validateTitle(String(repeating: "é", count: 30)) == nil)
    #expect(validateTitle(String(repeating: "👨‍👩‍👧‍👦", count: 3)) == .byteLimit)
}
@Test func matchingOriginalAndNumericOrder() {
    let locale = Locale(identifier: "en_US")
    let original = "👨‍👩‍👧‍👦 Cafe\u{301} 11"
    let range = titleMatch(original, query: "CAFE", locale: locale)
    #expect(range != nil)
    if let range {
        #expect(String(original[range]) == "Café")
        let ns = NSRange(range, in: original)
        #expect(Range(ns, in: original) == range)
        #expect(ns.location == original[..<range.lowerBound].utf16.count)
    }
    #expect(titleMatch(original, query: "", locale: locale) == nil)
    #expect(titleMatch(original, query: "missing", locale: locale) == nil)
    #expect(displayOrder("Lesson 2", "Lesson 11", locale: locale) == .orderedAscending)
}
