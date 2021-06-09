import Foundation

struct Favorite: Codable {
    let jobId: Int
    let isFavorited: Bool
    let username: String

    init(jobId: Int, isFavorited: Bool) {
        self.jobId = jobId
        self.isFavorited = isFavorited
        self.username = "nbasham"
    }
}
