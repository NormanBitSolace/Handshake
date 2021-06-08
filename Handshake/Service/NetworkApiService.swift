import Foundation
import Combine

final class NetworkApiService: ApiService {
    let api = JsonApi()
    let jobsPublisher = PassthroughSubject<[Job], Never>()
    private let host = "http://localhost:3000/"

    func getJobs() {
        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/jobs")!
        //  npm json-server http://localhost:3000/jobs
        api.get(url: url) { (result: Result<[Job], NetworkError>) in
            switch result {
                case .success(let model):
                    self.jobsPublisher.send(model)
                case .failure(_):
                    self.jobsPublisher.send([])
            }
        }
    }

    func createJobv2(_ job: Jobv2, completion: @escaping (Jobv2?) -> Void) {
        let url = URL(string: "\(host)jobsv2")!
        api.post(url: url, model: job) { (result: Result<Jobv2, NetworkError>) in
            switch result {
                case .success(let model):
                    completion(model)
                case .failure(_):
                    completion(nil)
            }
        }
    }

    func createEmployer(_ employer: Employer, completion: @escaping (Employerv2?) -> Void) {
        let url = URL(string: "\(host)employers")!
        api.post(url: url, model: employer) { (result: Result<Employerv2, NetworkError>) in
            switch result {
                case .success(let model):
                    completion(model)
                case .failure(_):
                    completion(nil)
            }
        }
    }

    func createRecruiter(_ recruiter: Recruiter, completion: @escaping (Recruiterv2?) -> Void) {
        let url = URL(string: "\(host)recruiters")!
        api.post(url: url, model: recruiter) { (result: Result<Recruiterv2, NetworkError>) in
            switch result {
                case .success(let model):
                    completion(model)
                case .failure(_):
                    completion(nil)
            }
        }
    }
}
