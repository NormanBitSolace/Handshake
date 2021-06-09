import Foundation

struct Job: Identifiable, Codable, Hashable {
    var id: Int?
    var isFavorited: Bool
    let title: String
    let salary: String
    let employer: Employer
    let recruiter: Recruiter
}

extension Job {
    var requireId: Int {
        guard let id = id else { fatalError("Job requires an id.") }
        return id
    }
}
