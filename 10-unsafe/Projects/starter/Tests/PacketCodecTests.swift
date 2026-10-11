import Foundation
import Testing
@testable import PacketCodec

@Test func knownPacket() throws {
    #expect(try decodePacket(PacketFixture.valid.bytes).samples == [4660, 255, 256])
    #expect(try decodePacket(PacketFixture.empty.bytes).samples.isEmpty)
}
@Test func checkedOffsets() throws {
    try Data([0xFF, 0x34, 0x12]).withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
        let value = try readLE16(bytes, at: 1)
        #expect(value == 4660)
        for offset in [-1, 2, 3, Int.max] {
            #expect(throws: PacketError.truncated) { try readLE16(bytes, at: offset) }
        }
    }
}
@Test func everyTruncatedPrefix() {
    let data = PacketFixture.valid.bytes
    for length in 0..<data.count {
        #expect(throws: (any Error).self) { try decodePacket(Data(data.prefix(length))) }
    }
}
@Test func malformedFixtures() {
    #expect(throws: PacketError.checksum) { try decodePacket(PacketFixture.checksum.bytes) }
    #expect(throws: PacketError.length) { try decodePacket(PacketFixture.count.bytes) }
    #expect(throws: PacketError.version) { try decodePacket(PacketFixture.version.bytes) }
    #expect(throws: PacketError.magic) { try decodePacket(Data([0,1,0,0,1])) }
    #expect(throws: PacketError.length) { try decodePacket(PacketFixture.valid.bytes + Data([0])) }
}
@Test func roundTripsAndReferenceAgreement() throws {
    for count in 0...128 {
        let packet = SensorPacket(samples: (0..<count).map { UInt16(truncatingIfNeeded: $0 * 997) })
        let data = try encodePacket(packet)
        #expect(try decodePacket(data) == packet)
        #expect(try decodePacketReference(data) == packet)
    }
    let extremes = SensorPacket(samples: [0, .max, 1, 256])
    #expect(try decodePacket(encodePacket(extremes)) == extremes)
}
@Test func maximumCount() throws {
    let largest = SensorPacket(samples: Array(repeating: .max, count: Int(UInt16.max)))
    #expect(try decodePacket(encodePacket(largest)) == largest)
    #expect(throws: PacketError.tooManySamples) { try encodePacket(SensorPacket(samples: Array(repeating: 0, count: 65_536))) }
}
@Test func rejectsEverySingleByteMutation() {
    let valid = Array(PacketFixture.valid.bytes)
    for index in valid.indices {
        var changed = valid; changed[index] ^= 1
        #expect(throws: (any Error).self) { try decodePacket(Data(changed)) }
        #expect(throws: (any Error).self) { try decodePacketReference(Data(changed)) }
    }
}
@Test func hexContract() throws {
    #expect(try parseHex("A5 01\n00 00 a6") == PacketFixture.empty.bytes)
    for bad in ["A", "GG", "0xA5", "-1", "Ａ５"] {
        #expect(throws: PacketError.invalidHex) { try parseHex(bad) }
    }
    #expect(try parseHex(hex(PacketFixture.valid.bytes)) == PacketFixture.valid.bytes)
}
@Test func failedDecodeKeepsOwnedResult() throws {
    var current = try decodePacket(PacketFixture.valid.bytes)
    let original = current
    do { current = try decodePacket(PacketFixture.checksum.bytes); Issue.record("Expected rejection") }
    catch { #expect(current == original) }
}
