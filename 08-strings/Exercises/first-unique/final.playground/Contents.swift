func firstUniqueCharacter(_ text: String) -> Character? {
    var counts: [Character: Int] = [:]
    for character in text { counts[character, default: 0] += 1 }
    return text.first { counts[$0] == 1 }
}

print(firstUniqueCharacter("swiss").map(String.init) ?? "none")
print(firstUniqueCharacter("aabb").map(String.init) ?? "none")
print(firstUniqueCharacter("👩🏽‍💻a👩🏽‍💻b").map(String.init) ?? "none")
