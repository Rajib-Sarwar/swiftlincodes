import Foundation
struct DurationSeconds: Decodable {
    let value: Int
    init(from decoder: any Decoder) throws {
        let c = try decoder.singleValueContainer()
        let raw = try c.decode(String.self)
        guard !raw.isEmpty, raw.utf8.allSatisfy({ (48...57).contains($0) }), let number = Int(raw) else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid duration")
        }
        value = number
    }
}
for json in [#""90""#, #""-1""#, #""1.5""#, "90"] {
    do { print(try JSONDecoder().decode(DurationSeconds.self, from: Data(json.utf8)).value) }
    catch { print("rejected") }
}
