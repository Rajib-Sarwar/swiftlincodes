# API review

Complete this before comparing your solution.

- Consumer: which screen needs this API?
- Three call sites: insertion, duplicate insertion, removal.
- Invariants: nonempty IDs, uniqueness, capacity, insertion order.
- Error policy: what fails and what remains unchanged?
- Surface: which declarations are public, internal, and private?
- Complexity and ownership: what happens when a caller edits a copy or snapshot?
- Release note: preserve add(_:) as a deprecated forwarding alias; removal is a later incompatible change.
- Deliberate omissions: explain why literals, dynamic lookup and wrappers are not necessary on SavedItems.

## Screenshot placeholder
<!-- SCREENSHOT TODO: Xcode Quick Help for insert(_:), including duplicate and capacity contract. -->
> Add a genuine Quick Help capture after reviewing the documentation.
