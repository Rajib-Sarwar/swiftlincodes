import Foundation
struct TagsResponse: Decodable {
    let tags: [String]
    enum CodingKeys: String, CodingKey { case tags }
    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        // TODO: Default only when the key is missing.
        tags = []
    }
}
for json in ["{}", #"{"tags":["swift"]}"#, #"{"tags":null}"#, #"{"tags":42}"#] {
    do { print(try JSONDecoder().decode(TagsResponse.self, from: Data(json.utf8)).tags) }
    catch { print("rejected") }
}
