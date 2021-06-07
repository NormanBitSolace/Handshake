import Foundation

struct Recruiter: Codable, Equatable, Hashable {
    let firstName: String
    let lastName: String
    let emailAddress: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, emailAddress
//        case email = "emailAddress"
    }
}
