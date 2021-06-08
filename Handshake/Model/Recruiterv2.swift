import Foundation

struct Recruiterv2: Identifiable, Codable, Equatable, Hashable {
    var id: Int?
    let firstName: String
    let lastName: String
    let emailAddress: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, emailAddress
//        case email = "emailAddress"
    }
}

extension Recruiterv2 {
    var requireId: Int {
        guard let id = id else { fatalError("Recruiterv2 requires an id.") }
        return id
    }
}
