import Foundation

struct Jobv2: Identifiable, Codable, Hashable {
    var id: Int?
    let title: String
    let salary: String
    let employer: Int
    let recruiter: Int
}

extension Jobv2 {
    var requireId: Int {
        guard let id = id else { fatalError("Jobv2 requires an id.") }
        return id
    }
}

