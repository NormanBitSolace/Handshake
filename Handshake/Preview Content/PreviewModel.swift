import Foundation

extension Job {
    static var example: Job {
        Job(id: 1, title: "Rock Star", salary: "1000000", employer: Employer(name: "Big Deal", address: "123 Main Street", description: "When you want to be a big deal, this is the place!"), recruiter: Recruiter(firstName: "Wanda", lastName: "Sykes", emailAddress: "sykes@icloud.com"))
    }
}

extension JobViewModel {
    static var example: JobViewModel {
        JobViewModel(model: Job.example)
    }
}
