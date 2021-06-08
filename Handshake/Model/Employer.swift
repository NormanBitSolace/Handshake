import Foundation

struct Employer: Codable, Equatable, Hashable {
    let name: String
    let address: String
    let description: String
}

extension Employer {
    enum CodingKeys: String, CodingKey {
        case name, address, description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        address = try container.decode(String.self, forKey: CodingKeys.address)
        let rawDescription = try container.decode(String.self, forKey: CodingKeys.description)
        description = rawDescription
            .replacingOccurrences(of: "\n\n", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
    }
}
