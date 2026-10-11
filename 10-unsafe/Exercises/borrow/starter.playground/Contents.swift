import Foundation
func checksum8(_ data: Data) -> UInt8 {
    data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
        // TODO: Sum initialized bytes modulo 256; return a value, never the buffer.
        return 0
    }
}
print(checksum8(Data([250, 10, 1])))
print(checksum8(Data()))
