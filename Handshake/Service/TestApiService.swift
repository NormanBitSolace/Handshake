import Foundation
import Combine

final class TestApiService: ApiService {
    let jobsPublisher = PassthroughSubject<[Job], Never>()

    func getJobs() {
        let models = [
            Job(id: 1, title: "Rock Star", salary: 1000000.00, employer: Employer(name: "Big Deal", address: "123 Main Street", description: "When you want to be a big deal, this is the place!"), recruiter: Recruiter(firstName: "Wanda", lastName: "Sykes", email: "sykes@icloud.com"))
        ]
        self.jobsPublisher.send(models)
    }
}
