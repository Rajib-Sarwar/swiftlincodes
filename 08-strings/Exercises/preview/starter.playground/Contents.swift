func titlePreview(_ text: String, limit: Int) -> String {
    // TODO: Preserve complete Characters and include the ellipsis in the limit.
    return ""
}

print(titlePreview("Swift", limit: 4))
print(titlePreview("👨‍👩‍👧‍👦abc", limit: 3))
print(titlePreview("Go", limit: 2))
