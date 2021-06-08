import Foundation
import Combine

final class NetworkApiService: ApiService {

    let api = JsonApi()
    let jobsPublisher = PassthroughSubject<[Job], Never>()
    //  npm json-server http://localhost:3000/jobs
    //  handshake https://ios-interview.joinhandshake-internal.com/jobs
    private let host = "http://localhost:3000/"

    func getJobs() {
        let url = URL(string: "\(host)jobs")!
        api.get(url: url) { (result: Result<[Job], NetworkError>) in
            switch result {
                case .success(let model):
                    self.jobsPublisher.send(model)
                case .failure(_):
                    self.jobsPublisher.send([])
            }
        }
    }

    func createJob(_ job: Job, completion: @escaping () -> Void) {
        let url = URL(string: "\(host)jobs")!
        api.post(url: url, model: job) { (result: Result<Job, NetworkError>) in
            switch result {
                case .success(let model):
                    print("Created new job with id \(model.requireId).")
                case .failure(let error):
                    print("Failed to create new job with error \(error).")
            }
            completion()
        }
    }

    func updateJob(_ job: Job, completion: @escaping () -> Void) {
        let url = URL(string: "\(host)jobs/\(job.requireId)")!
        api.put(url: url, model: job) { (result: Result<Job, NetworkError>) in
            switch result {
                case .success(let model):
                    print("Updated job with id \(model.requireId).")
                case .failure(let error):
                    print("Failed to update job with error \(error).")
            }
            completion()
        }
    }

    func deleteJob(id: Int, completion: @escaping () -> Void) {
        let url = URL(string: "\(host)jobs/\(id)")!
        api.delete(url: url) { result in
            switch result {
                case .success(_):
                    print("Deleted job with id \(id).")
                case .failure(let error):
                    print("Failed to delete job with error \(error).")
            }
            completion()
        }
    }
}
