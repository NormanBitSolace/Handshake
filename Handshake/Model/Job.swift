import Foundation

struct Job: Identifiable, Codable, Hashable {
    var id: Int?
    let title: String
    let salary: Double
    let employer: Employer
    let recruiter: Recruiter
}

extension Job {

    enum CodingKeys: String, CodingKey {
        case id, title, salary, employer, recruiter
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.title = try container.decode(String.self, forKey: CodingKeys.title)
        let salaryString = try container.decode(String.self, forKey: CodingKeys.salary)
        if let salaryDouble = Double(salaryString) {
            self.salary = salaryDouble
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.salary], debugDescription: "Could not parse salary string \(salaryString) into Double.")
            throw DecodingError.dataCorrupted(context)
        }
        self.employer = try container.decode(Employer.self, forKey: CodingKeys.employer)
        self.recruiter = try container.decode(Recruiter.self, forKey: CodingKeys.recruiter)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode("\(salary)", forKey: .salary)
        try container.encode(employer, forKey: .employer)
        try container.encode(recruiter, forKey: .recruiter)
    }
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
