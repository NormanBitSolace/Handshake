import Combine

protocol ApiService: AnyObject {
    var jobsPublisher: PassthroughSubject<[Job], Never> { get }
    func getJobs()
    func createJob(_ job: Job, completion: @escaping () -> Void)
    func updateJob(_ job: Job, completion: @escaping () -> Void)
    func deleteJob(id: Int, completion: @escaping () -> Void)
}
