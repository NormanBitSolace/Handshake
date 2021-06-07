import Combine

protocol ApiService: AnyObject {
    var jobsPublisher: PassthroughSubject<[Job], Never> { get }
    func getJobs()
}
