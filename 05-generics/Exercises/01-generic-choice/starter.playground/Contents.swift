// Keep the chosen receipt’s type
// Implement choose<Value>(_:or:useFirst:) returning Value. Do not use Any or a cast.
// Print the chosen receipt reference for true, then for false.
// Reuse the function for 10 and 20, selecting the second value.

struct CardReceipt { let reference: String }
// TODO: Write choose<Value>(_:or:useFirst:) -> Value.
// Return first when useFirst is true, otherwise return second.

let first = CardReceipt(reference: "card-101")
let second = CardReceipt(reference: "card-202")
// TODO: Choose each receipt in turn and print its reference.
// Also use the same function to choose between Int values 10 and 20.

