import Foundation

struct JobViewModel {
    let id: Int
    let title: String
    let salary: String
    let employer: Employer
    let recruiter: Recruiter
    let isFavorited: Bool
    var employerLogo: URL?
    var employerImage: URL?

    func setFavorite(_ newFavorite: Bool) -> JobViewModel {
        JobViewModel(id: id, title: title, salary: salary, employer: employer, recruiter: recruiter, isFavorited: newFavorite)
    }
}

extension JobViewModel {
    var favorite: Favorite {
        Favorite(jobId: id, isFavorited: isFavorited)
    }

    var job: Job {
        var amount: Decimal = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let number = formatter.number(from: salary) {
            amount = number.decimalValue
        }
        return Job(id: id, isFavorited: isFavorited, title: title, salary: "\(amount)", employer: employer, recruiter: recruiter)
    }
}

extension JobViewModel {
    init(model: Job) {
        self.id = model.requireId
        self.title = model.title
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let salaryDouble = Double(model.salary),
           let formattedSalary = formatter.string(from: salaryDouble as NSNumber) {
            salary = "\(formattedSalary)"
        } else {
            salary = "Unknown"
        }
        self.employer = model.employer
        self.recruiter = model.recruiter
        self.isFavorited = model.isFavorited
        if let url = URL(string: employer.logo) {
            employerLogo = url
        }
        if let url = URL(string: employer.image) {
            employerImage = url
        }
    }
}
