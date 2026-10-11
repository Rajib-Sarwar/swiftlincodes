import Foundation
func readLE16(_ bytes: UnsafeRawBufferPointer, at offset: Int) -> UInt16? {
    // TODO: Validate offset and remaining length before loading two bytes.
    return nil
}
let data = Data([0xFF, 0x34, 0x12])
data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
    for offset in [1, 2, -1, Int.max] {
        print(readLE16(bytes, at: offset).map(String.init) ?? "rejected")
    }
}
