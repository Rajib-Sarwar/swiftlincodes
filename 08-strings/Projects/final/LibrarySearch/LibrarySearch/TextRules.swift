import Foundation

enum RenameIssue: String, Error {
    case empty = "Enter a title."
    case characterLimit = "Use at most 30 characters."
    case byteLimit = "Use at most 60 UTF-8 bytes."
}

func validateTitle(_ text: String) -> RenameIssue? {
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return .empty }
    guard text.count <= 30 else { return .characterLimit }
    guard text.utf8.count <= 60 else { return .byteLimit }
    return nil
}

// Return a range in the original title. Never transfer indices from folded text.
func titleMatch(_ title: String, query: String, locale: Locale) -> Range<String.Index>? {
    guard !query.isEmpty else { return nil }
    guard let match = title.range(of: query, options: [.caseInsensitive, .diacriticInsensitive], locale: locale) else { return nil }
    // A folded match can end before a combining mark. Highlight whole clusters.
    let fullCharacters = (title as NSString).rangeOfComposedCharacterSequences(for: NSRange(match, in: title))
    return Range(fullCharacters, in: title)
}

func displayOrder(_ lhs: String, _ rhs: String, locale: Locale) -> ComparisonResult {
    lhs.compare(rhs, options: [.numeric, .caseInsensitive], locale: locale)
}

func titlePreview(_ text: String, limit: Int) -> String {
    guard limit > 0 else { return "" }
    let head = text.prefix(limit)
    guard head.endIndex != text.endIndex else { return text }
    return String(text.prefix(limit - 1)) + "…"
}

func isExactPalindrome(_ text: String) -> Bool {
    var left = text.startIndex
    var right = text.endIndex
    while left < right {
        right = text.index(before: right)
        if left >= right { break }
        guard text[left] == text[right] else { return false }
        left = text.index(after: left)
    }
    return true
}

func firstUniqueCharacter(_ text: String) -> Character? {
    var counts: [Character: Int] = [:]
    for character in text { counts[character, default: 0] += 1 }
    return text.first { counts[$0] == 1 }
}
