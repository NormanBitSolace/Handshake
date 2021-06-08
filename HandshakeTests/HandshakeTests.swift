import XCTest
@testable import Handshake

class HandshakeTests: XCTestCase {
    private let host = "http://localhost:3000/"
    let job = Job(id: nil, title: "Rock Star", salary: 1000000.0, employer: Employer(name: "Big Deal", address: "123 Main Street", description: "When you want to be a big deal, this is the place!"), recruiter: Recruiter(firstName: "Wanda", lastName: "Sykes", email: "sykes@icloud.com"))
    let service = NetworkApiService()

    func testPost() throws {
        let exp = expectation(description: "POST test")
        let url = URL(string: "\(host)jobs")!

        service.api.post(url: url, model: job) { ( result: Result<Job, NetworkError>) in
            switch result {
                case .success(_):
                    exp.fulfill()
                case .failure(let error):
                    print("Error on POST \(error).")
            }
        }
        waitForExpectations(timeout: 3)
    }
}


