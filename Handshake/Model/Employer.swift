import Foundation

struct Employer: Codable, Equatable, Hashable {

    let name: String
    let address: String
    let description: String
    let logo: String
    let image: String

    init(name: String, address: String, description: String) {
        self.name = name
        self.address = address
        self.description = description
        self.logo = "https://source.unsplash.com/random/50x50"
        self.image = "https://source.unsplash.com/random/400x100"
    }
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
        self.logo = "https://source.unsplash.com/random/50x50"
        self.image = "https://source.unsplash.com/random/400x100"
    }
}
