import Foundation
func readLE16(_ bytes: UnsafeRawBufferPointer, at offset: Int) -> UInt16? {
    guard offset >= 0, offset <= bytes.count, bytes.count - offset >= 2 else { return nil }
    return UInt16(littleEndian: bytes.loadUnaligned(fromByteOffset: offset, as: UInt16.self))
}
let data = Data([0xFF, 0x34, 0x12])
data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
    for offset in [1, 2, -1, Int.max] {
        print(readLE16(bytes, at: offset).map(String.init) ?? "rejected")
    }
}
