import Foundation

struct JobViewModel {
    let id: Int
    let title: String
    let salary: String
    let employer: Employer
    let recruiter: Recruiter
}

extension JobViewModel {
    init(model: Job) {
        self.id = model.requireId
        self.title = model.title
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let formattedSalary = formatter.string(from: floor(model.salary) as NSNumber) {
            salary = "\(formattedSalary)"
        } else {
            salary = "Unknown"
        }
        self.employer = model.employer
        self.recruiter = model.recruiter
    }
}
