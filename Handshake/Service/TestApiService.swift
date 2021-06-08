import Foundation
import Combine

final class TestApiService: ApiService {
    let jobsPublisher = PassthroughSubject<[Job], Never>()
    private var jobs: [Job] = [
        Job(id: 1, title: "Rock Star", salary: 1000000.00, employer: Employer(name: "Big Deal", address: "123 Main Street", description: "When you want to be a big deal, this is the place!"), recruiter: Recruiter(firstName: "Wanda", lastName: "Sykes", email: "sykes@icloud.com"))
    ]

    func getJobs() {
        self.jobsPublisher.send(jobs)
    }

    func createJob(_ job: Job, completion: @escaping () -> Void) {
        jobs.append(job)
    }

    func updateJob(_ job: Job, completion: @escaping () -> Void) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index] = job
        }
    }

    func deleteJob(id: Int, completion: @escaping () -> Void) {
        if let index = jobs.firstIndex(where: { $0.id == id }) {
            jobs.remove(at: index)
        }
    }
}
