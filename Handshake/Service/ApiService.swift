import Combine

protocol ApiService: AnyObject {
    var jobsPublisher: PassthroughSubject<[Job], Never> { get }
    func getJobs()
    func createEmployer(_ employer: Employer, completion: @escaping (Employerv2?) -> Void)
    func createRecruiter(_ recruiter: Recruiter, completion: @escaping (Recruiterv2?) -> Void)
    func createJobv2(_ job: Jobv2, completion: @escaping (Jobv2?) -> Void)
}
