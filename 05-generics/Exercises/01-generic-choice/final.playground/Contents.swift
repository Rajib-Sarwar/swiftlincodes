// Keep the chosen receipt’s type
// Reference solution: attempt the starter first.

struct CardReceipt { let reference: String }
func choose<Value>(_ first: Value, or second: Value, useFirst: Bool) -> Value {
    useFirst ? first : second
}
let first = CardReceipt(reference: "card-101")
let second = CardReceipt(reference: "card-202")
print(choose(first, or: second, useFirst: true).reference)
print(choose(first, or: second, useFirst: false).reference)
print(choose(10, or: 20, useFirst: false))
