import Foundation

struct Recruiter: Codable, Equatable, Hashable {
    let firstName: String
    let lastName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case email = "emailAddress"
    }
}
