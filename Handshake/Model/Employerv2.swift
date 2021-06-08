import Foundation

struct Employerv2: Identifiable, Codable, Equatable, Hashable {
    var id: Int?
    let name: String
    let address: String
    let description: String
}

extension Employerv2 {
    var requireId: Int {
        guard let id = id else { fatalError("Employerv2 requires an id.") }
        return id
    }
}

