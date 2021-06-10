import Foundation
import Combine

final class NetworkApiService {
    let jobsPublisher = PassthroughSubject<[Job], Never>()
    let updateFavoritePublisher = PassthroughSubject<Favorite, Never>()
    let isLoadingPublisher = PassthroughSubject<Bool, Never>()
    private let cache = NSCache<NSString, NSData>()
    private let cacheKey = NSString("cacheKey")
    private let cacheJobs = false
    /*@Published*/ var isLoadingPage = false
    private var currentPage = 1

    func loadMoreJobs(existingJobs: [Job]) {
        guard !isLoadingPage else {
            return
        }

        isLoadingPage = true
        isLoadingPublisher.send(isLoadingPage)
        if let cachedJobs = loadCachedJobs() {
            jobsPublisher.send(cachedJobs)
            print("Jobs cached returning saved jobs.")
            return
        }
        print("No jobs cached hitting server.")
        let url = URL(string: "http://localhost:3000/jobs?_page=1&username=nbasham")!
//        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/jobs?username=nbasham")!
        //  npm json-server http://localhost:3000/jobs
        get(url: url) { (result: Result<[Job], NetworkError>) in
            switch result {
                case .success(let model):
                    self.currentPage += 1
                    self.isLoadingPage = false
                    self.isLoadingPublisher.send(self.isLoadingPage)
                    self.cacheJobs(jobs: model)
                    self.jobsPublisher.send(existingJobs + model)
                case .failure(_):
                    self.jobsPublisher.send([])
                    self.jobsPublisher.send(existingJobs)
            }
        }
    }

    func getJobs() {
        if let cachedJobs = loadCachedJobs() {
            jobsPublisher.send(cachedJobs)
            print("Jobs cached returning saved jobs.")
            return
        }
        print("No jobs cached hitting server.")
        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/jobs?username=nbasham")!
        //  npm json-server http://localhost:3000/jobs
        get(url: url) { (result: Result<[Job], NetworkError>) in
            switch result {
                case .success(let model):
                    self.cacheJobs(jobs: model)
                    self.jobsPublisher.send(model)
                case .failure(_):
                    self.jobsPublisher.send([])
            }
        }
    }

    func cacheJobs(jobs: [Job]) {
        guard cacheJobs else { return }
        if let data = try? JSONEncoder().encode(jobs) {
            let nsdata = NSData(data: data)
            self.cache.setObject(nsdata, forKey: self.cacheKey)
            print("Saved jobs to cache.")
            if let url = cacheURL {
                print("Saved jobs to disk.")
                try? data.write(to: url)
            }
        }
    }

    private func loadCachedJobs() -> [Job]? {
        guard cacheJobs else { return nil }
        if let nsdata = cache.object(forKey: cacheKey) {
            let data = Data(nsdata)
            if let jobs = try? JSONDecoder().decode([Job].self, from: data) {
                print("Loaded cached jobs from NSCache.")
                   return jobs
                }
        } else if let url = cacheURL,
                  let data = try? Data.init(contentsOf: url),
                  let jobs = try? JSONDecoder().decode([Job].self, from: data) {
            print("Loaded jobs from disk.")
            return jobs
        }
        print("Failed to load cached jobs.")
        return nil
    }

    private var cacheURL: URL? {
        if let cacheDirectoryURL =
            try? FileManager.default.url(for: .cachesDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true) {
            return cacheDirectoryURL.appendingPathComponent(cacheKey as String)
        }
        return nil
    }

    func toggleFavorite(favorite: Favorite) {
        let toggledFavorite = Favorite(jobId: favorite.jobId, isFavorited: !favorite.isFavorited)
        guard let data = try? JSONEncoder().encode(toggledFavorite) else {
            self.updateFavoritePublisher.send(favorite)
            return
        }
        let url = URL(string: "https://ios-interview.joinhandshake-internal.com/favorites")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { _, _, error in
            self.updateFavoritePublisher.send(error == nil ? toggledFavorite : favorite)
        }.resume()
    }

    private func get<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.system(error.localizedDescription)))
                return
            }
            if let data = data {
                if let model = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(model))
                } else {
                    completion(.failure(.decodeFailed))
                }
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
    }
}
