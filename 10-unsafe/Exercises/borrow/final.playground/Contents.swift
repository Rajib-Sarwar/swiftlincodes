import Foundation
func checksum8(_ data: Data) -> UInt8 {
    data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
        return bytes.reduce(UInt8(0)) { $0 &+ $1 }
    }
}
print(checksum8(Data([250, 10, 1])))
print(checksum8(Data()))
