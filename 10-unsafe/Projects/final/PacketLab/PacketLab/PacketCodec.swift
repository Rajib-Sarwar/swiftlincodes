import Foundation

enum PacketError: Error, Equatable {
    case truncated, magic, version, length, checksum, tooManySamples, invalidHex, unfinished
}
struct SensorPacket: Equatable, Sendable {
    let samples: [UInt16]
}

// The subtraction follows the nonnegative/in-range check: offset + width cannot overflow.
func readLE16(_ bytes: UnsafeRawBufferPointer, at offset: Int) throws -> UInt16 {
    guard offset >= 0, offset <= bytes.count, bytes.count - offset >= 2 else {
        throw PacketError.truncated
    }
    let native = bytes.loadUnaligned(fromByteOffset: offset, as: UInt16.self)
    return UInt16(littleEndian: native)
}

func checksum8(_ bytes: UnsafeRawBufferPointer) -> UInt8 {
    bytes.reduce(UInt8(0)) { $0 &+ $1 }
}

// Borrowed pointer stays inside this closure. Only owned Swift values leave it.
func decodePacket(_ data: Data) throws -> SensorPacket {
    try data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
        guard bytes.count >= 5 else { throw PacketError.truncated }
        guard bytes[0] == 0xA5 else { throw PacketError.magic }
        guard bytes[1] == 1 else { throw PacketError.version }
        let count = Int(try readLE16(bytes, at: 2))
        // UInt16 count is bounded, so 5 + count * 2 fits the supported Int platforms.
        guard bytes.count == 5 + count * 2 else { throw PacketError.length }
        let body = UnsafeRawBufferPointer(rebasing: bytes.dropLast())
        guard checksum8(body) == bytes[bytes.count - 1] else { throw PacketError.checksum }
        var samples: [UInt16] = []
        samples.reserveCapacity(count)
        for i in 0..<count { samples.append(try readLE16(bytes, at: 4 + i * 2)) }
        return SensorPacket(samples: samples)
    }
}

// A simple safe baseline: explicit byte assembly, no typed loads or pointers.
func decodePacketReference(_ data: Data) throws -> SensorPacket {
    let bytes = Array(data)
    guard bytes.count >= 5 else { throw PacketError.truncated }
    guard bytes[0] == 0xA5 else { throw PacketError.magic }
    guard bytes[1] == 1 else { throw PacketError.version }
    let count = Int(bytes[2]) | (Int(bytes[3]) << 8)
    guard bytes.count == 5 + count * 2 else { throw PacketError.length }
    guard bytes.dropLast().reduce(UInt8(0), { $0 &+ $1 }) == bytes.last else { throw PacketError.checksum }
    return SensorPacket(samples: (0..<count).map {
        let offset = 4 + $0 * 2
        return UInt16(bytes[offset]) | (UInt16(bytes[offset + 1]) << 8)
    })
}

func encodePacket(_ packet: SensorPacket) throws -> Data {
    guard let count = UInt16(exactly: packet.samples.count) else { throw PacketError.tooManySamples }
    var bytes: [UInt8] = [0xA5, 1, UInt8(truncatingIfNeeded: count), UInt8(count >> 8)]
    for sample in packet.samples {
        bytes.append(UInt8(truncatingIfNeeded: sample))
        bytes.append(UInt8(sample >> 8))
    }
    bytes.append(bytes.reduce(UInt8(0)) { $0 &+ $1 })
    return Data(bytes)
}

func parseHex(_ text: String) throws -> Data {
    let fields = text.split(whereSeparator: { $0.isWhitespace })
    guard fields.count <= 131_075 else { throw PacketError.length }
    let bytes = try fields.map { field -> UInt8 in
        guard field.utf8.count == 2,
              field.utf8.allSatisfy({ (48...57).contains($0) || (65...70).contains($0) || (97...102).contains($0) }),
              let byte = UInt8(field, radix: 16) else { throw PacketError.invalidHex }
        return byte
    }
    return Data(bytes)
}
func hex(_ data: Data) -> String { data.map { String(format: "%02X", $0) }.joined(separator: " ") }
func packetMessage(_ error: any Error) -> String {
    switch error {
    case PacketError.truncated: "Truncated packet: need a complete header and checksum."
    case PacketError.magic: "Wrong magic byte: expected A5."
    case PacketError.version: "Unsupported version: expected 01."
    case PacketError.length: "Length does not match the declared sample count."
    case PacketError.checksum: "Checksum mismatch. Previous samples retained."
    case PacketError.tooManySamples: "Too many samples for a UInt16 count."
    case PacketError.invalidHex: "Enter whitespace-separated two-digit hexadecimal bytes."
    case PacketError.unfinished: "Complete the TODOs in PacketCodec.swift."
    default: "Could not decode packet."
    }
}
enum PacketFixture: String, CaseIterable, Identifiable {
    case valid = "Three samples", empty = "Empty payload", truncated = "Truncated", checksum = "Bad checksum", count = "Wrong count", version = "Future version"
    var id: String { rawValue }
    var bytes: Data {
        switch self {
        case .valid: Data([0xA5,1,3,0,0x34,0x12,0xFF,0,0,1,0xEF])
        case .empty: Data([0xA5,1,0,0,0xA6])
        case .truncated: Data([0xA5,1,3])
        case .checksum: Data([0xA5,1,3,0,0x34,0x12,0xFF,0,0,1,0])
        case .count: Data([0xA5,1,4,0,0x34,0x12,0xFF,0,0,1,0xF0])
        case .version: Data([0xA5,2,0,0,0xA7])
        }
    }
}
