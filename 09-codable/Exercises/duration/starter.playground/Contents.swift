import Foundation
struct DurationSeconds: Decodable {
    let value: Int
    init(from decoder: any Decoder) throws {
        let c = try decoder.singleValueContainer()
        let raw = try c.decode(String.self)
        // TODO: Reject everything except nonnegative ASCII decimal text fitting Int.
        value = 0
    }
}
for json in [#""90""#, #""-1""#, #""1.5""#, "90"] {
    do { print(try JSONDecoder().decode(DurationSeconds.self, from: Data(json.utf8)).value) }
    catch { print("rejected") }
}
