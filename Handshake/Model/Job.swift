import Foundation

struct Job: Identifiable, Codable, Hashable {
    var id: Int?
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

extension Sequence where Element == Job {

    var uniqueEmployers: [Employer] {
        Array(Set(self.map { $0.employer }))
    }

    var uniqueRecruiters: [Recruiter] {
        Array(Set(self.map { $0.recruiter }))
    }
}
