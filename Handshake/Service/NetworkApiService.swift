import Foundation
import Combine

final class NetworkApiService: ApiService {
    let api = JsonApi()
    let jobsPublisher = PassthroughSubject<[Job], Never>()

    func getJobs() {
        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/jobs?username=nbasham")!
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

    func setJobFavorite(job: JobViewModel) {
        struct Favorite: Codable {
            let id: Int
            let isFavorited: Bool
            let username: String
        }
        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/jobs")!
        api.post(url: url, model: Favorite(id: job.id, isFavorited: job.isFavorited, username: "nbasham")) { (result: Result<Favorite, NetworkError>) in
            switch result {
                case .success(_):
                    print("Successfully set favoited.")
                case .failure(let error):
                    print("Failed setting favoited \(error).")
            }
        }
    }

}
