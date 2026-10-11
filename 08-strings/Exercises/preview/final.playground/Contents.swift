func titlePreview(_ text: String, limit: Int) -> String {
    guard limit > 0 else { return "" }
    let head = text.prefix(limit)
    guard head.endIndex != text.endIndex else { return text }
    return String(text.prefix(limit - 1)) + "…"
}

print(titlePreview("Swift", limit: 4))
print(titlePreview("👨‍👩‍👧‍👦abc", limit: 3))
print(titlePreview("Go", limit: 2))
