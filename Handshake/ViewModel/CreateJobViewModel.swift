import Foundation

class CreateJobViewModel: ObservableObject {
    @Published var titleText: String = ""
    @Published var salaryText: String = ""
    @Published var employerText: String = ""
    @Published var recruiterText: String = ""
    let employers: [Employer]
    let recruiters: [Recruiter]
    let employerNames: [String]
    let recruiterNames: [String]
    var id: Int? = nil

    init(employers: [Employer], recruiters: [Recruiter], job: JobViewModel? = nil) {
        self.employers = employers
        self.recruiters = recruiters
        employerNames = employers.map { "\($0.name)" }
        recruiterNames = recruiters.map { "\($0.firstName) \($0.lastName)" }
        if let job = job {
            id = job.id
            titleText = job.title
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            if let number = formatter.number(from: job.salary) {
                salaryText = "\(number.decimalValue)"
            }
            employerText = job.employer.name
            recruiterText = "\(job.recruiter.firstName) \(job.recruiter.lastName)"
        }
    }

    var incompleteForm: Bool {
        titleText.count < 3 || salaryText.count < 3 || employerText.isEmpty || recruiterText.isEmpty || Double(salaryText) == nil
    }

    var job: Job? {
        if let employerObj = employers.first(where: { $0.name == employerText }),
           let recruiterObj = recruiters.first(where: { "\($0.firstName) \($0.lastName)" == recruiterText }),
           let salary = Double(salaryText) {
            return Job(id: id, title: titleText, salary: salary, employer: employerObj, recruiter: recruiterObj)
        }
        return nil
    }
}

