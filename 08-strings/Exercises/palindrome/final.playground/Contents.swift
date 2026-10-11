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

print(isExactPalindrome("👩🏽‍💻a👩🏽‍💻"))
print(isExactPalindrome("Aa"))
print(isExactPalindrome(""))
