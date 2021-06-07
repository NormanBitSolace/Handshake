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
}
