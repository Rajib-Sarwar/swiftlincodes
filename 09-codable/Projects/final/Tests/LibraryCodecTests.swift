import Foundation
import Testing
@testable import LibraryCodec

@Test func validAndFutureStatus() throws {
    let videos = try decodeLibrary(Data(Fixture.valid.json.utf8))
    #expect(videos.count == 2)
    #expect(videos[0].duration == 90)
    #expect(videos[0].summary == nil)
    #expect(videos[1].availability == .unknown("scheduled"))
    #expect(videos[1].tags.isEmpty)
}
@Test func presencePolicy() throws {
    #expect(try decodeLibrary(Data(Fixture.missingTags.json.utf8))[0].tags.isEmpty)
    #expect(throws: (any Error).self) { try decodeLibrary(Data(Fixture.nullTags.json.utf8)) }
    let mixed = Fixture.valid.json.replacingOccurrences(of: #""tags":["swift"]"#, with: #""tags":["swift",1]"#)
    #expect(throws: (any Error).self) { try decodeLibrary(Data(mixed.utf8)) }
    let wrongSummary = Fixture.valid.json.replacingOccurrences(of: #""summary":null"#, with: #""summary":42"#)
    #expect(throws: (any Error).self) { try decodeLibrary(Data(wrongSummary.utf8)) }
}
@Test func durationContract() throws {
    let decoder = JSONDecoder()
    for raw in ["0", "090", String(Int.max)] {
        let data = try JSONEncoder().encode(raw)
        #expect(try decoder.decode(DurationSeconds.self, from: data).value == Int(raw))
    }
    for raw in ["", "-1", "+1", "1.5", " 90", "١٢", String(Int.max) + "0"] {
        let data = try JSONEncoder().encode(raw)
        #expect(throws: (any Error).self) { try decoder.decode(DurationSeconds.self, from: data) }
    }
    #expect(throws: (any Error).self) { try decoder.decode(DurationSeconds.self, from: Data("90".utf8)) }
    #expect(String(decoding: try JSONEncoder().encode(DurationSeconds(90)), as: UTF8.self) == #""90""#)
}
@Test func failurePath() throws {
    do {
        _ = try decodeLibrary(Data(Fixture.wrongDuration.json.utf8))
        Issue.record("Expected type mismatch")
    } catch { #expect(decodingDiagnostic(error) == "Wrong type at $.videos[0].duration_seconds") }
    let missing = Fixture.valid.json.replacingOccurrences(of: #""title":"Café","summary""#, with: #""summary""#)
    do { _ = try decodeLibrary(Data(missing.utf8)); Issue.record("Expected missing key") }
    catch { #expect(decodingDiagnostic(error) == "Missing key at $.videos[0].title") }
}
@Test func validationAndDates() {
    #expect(throws: LibraryFailure.duplicateID) { try decodeLibrary(Data(Fixture.duplicate.json.utf8)) }
    #expect(throws: (any Error).self) { try decodeLibrary(Data(Fixture.invalidDate.json.utf8)) }
    let blank = Fixture.valid.json.replacingOccurrences(of: "Café", with: "   ")
    #expect(throws: LibraryFailure.invalidVideo) { try decodeLibrary(Data(blank.utf8)) }
}
@Test func migrationAndRoundTrip() throws {
    let old = try decodeCache(Data(legacyCache.utf8))
    #expect(old[0].availability == .ready)
    #expect(old[0].tags.isEmpty)
    let current = try decodeLibrary(Data(Fixture.valid.json.utf8))
    let data = try encodeCache(current)
    #expect(try decodeCache(data) == current)
    #expect(try JSONDecoder().decode(CacheEnvelope.self, from: data).version == 2)
    #expect(throws: LibraryFailure.unsupportedVersion(99)) { try decodeCache(Data(#"{"version":99}"#.utf8)) }
    #expect(throws: (any Error).self) { try decodeCache(Data(#"{"version":2,"videos":[{"id":"v1"}]}"#.utf8)) }
}
@Test func diskPreservesLastGoodData() throws {
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: directory) }
    let cache = LibraryCache(url: directory.appendingPathComponent("library.json"))
    let valid = try decodeLibrary(Data(Fixture.valid.json.utf8))
    try cache.save(valid)
    let bytes = try Data(contentsOf: cache.url)
    #expect(throws: LibraryFailure.duplicateID) { try cache.save([valid[0], valid[0]]) }
    #expect(try Data(contentsOf: cache.url) == bytes)
    #expect(try cache.load() == valid)
}
@Test func failedImportDoesNotReplaceState() throws {
    var current = try decodeLibrary(Data(Fixture.valid.json.utf8))
    let original = current
    do { current = try decodeLibrary(Data(Fixture.nullTags.json.utf8)); Issue.record("Expected failure") }
    catch { #expect(current == original) }
}
