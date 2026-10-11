import Foundation

enum RenameIssue: String, Error {
    case empty = "Enter a title."
    case characterLimit = "Use at most 30 characters."
    case byteLimit = "Use at most 60 UTF-8 bytes."
}

func validateTitle(_ text: String) -> RenameIssue? {
    // TODO: Check blank input, Character budget, then UTF-8 byte budget.
    return .empty
}

// Return a range in the original title. Never transfer indices from folded text.
func titleMatch(_ title: String, query: String, locale: Locale) -> Range<String.Index>? {
    // TODO: Search title, expand the match to complete composed characters,
    // and convert the expanded NSRange back into this title.
    return nil
}

func displayOrder(_ lhs: String, _ rhs: String, locale: Locale) -> ComparisonResult {
    lhs.compare(rhs, options: [.numeric, .caseInsensitive], locale: locale)
}

func titlePreview(_ text: String, limit: Int) -> String {
    // TODO: Preserve complete Characters and include the ellipsis in the limit.
    return ""
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
