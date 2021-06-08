import Foundation
import Combine

final class AppLogic: ObservableObject {
    @Published var state: AppState
    @Published var viewModel: AppViewModel
    private var subscriptions = Set<AnyCancellable>()
    weak var service: ApiService?

    init(service: ApiService) {
        self.service = service
        state = AppState()
        viewModel = AppViewModel()

        //  Listen for a server response to service.getJobs()
        service.jobsPublisher
            .sink { jobs in
                self.state.jobs = jobs
                self.migrate(jobs: jobs)
            }
            .store(in: &subscriptions)

        //  Listen for state.jobs changes and update view model
        state.$jobs
            .receive(on: DispatchQueue.main)
            .map { $0.map { JobViewModel(model: $0) } }
            .assign(to: \.viewModel.jobViewModels, on: self)
            .store(in: &subscriptions)

        //  Listens for a UI request for jobs and call service.getJobs()
        viewModel.getJobsPublisher
            .sink {
                self.service?.getJobs()
            }
            .store(in: &subscriptions)
    }

    func matchEmployer(_ employer: Employer, in list: [Employerv2]) -> Int {
        if let emp = list.first(where: { $0.name == employer.name }) {
            return emp.requireId
        }
        fatalError()
    }

    func matchRecruiter(_ recruiter: Recruiter, in list: [Recruiterv2]) -> Int {
        if let rec = list.first(where: { $0.emailAddress == recruiter.emailAddress }) {
            return rec.requireId
        }
        fatalError()
    }

    private func migrate(jobs: [Job]) {
        createEmployers(employers: jobs.uniqueEmployers) { employersv2 in
            self.createRecruiters(recruiters: jobs.uniqueRecruiters) { recruitersv2 in
                for job in jobs {
                    let employerId = self.matchEmployer(job.employer, in: employersv2)
                    let recruiterId = self.matchRecruiter(job.recruiter, in: recruitersv2)
                    let jobv2 = Jobv2(id: nil, title: job.title, salary: job.salary, employer: employerId, recruiter: recruiterId)
                    self.service?.createJobv2(jobv2) { optionalJob in
                        if let newJob = optionalJob {
                            self.state.jobsv2.append(newJob)
                        }
                    }
                }
            }
        }
    }

    private func createEmployers(employers: [Employer], completion: @escaping ([Employerv2]) -> Void) {
        var createdEmployers = [Employerv2]()
        let group = DispatchGroup()
        for employer in employers {
            group.enter()
            service?.createEmployer(employer) { emp in
                if let empv2 = emp {
                    createdEmployers.append(empv2)
                }
                group.leave()
            }
            group.notify(queue: .main) { [] in
                completion(createdEmployers)
            }
        }
    }

    private func createRecruiters(recruiters: [Recruiter], completion: @escaping ([Recruiterv2]) -> Void) {
        var createdRecruiters = [Recruiterv2]()
        let group = DispatchGroup()
        for recruiter in recruiters {
            group.enter()
            service?.createRecruiter(recruiter) { recruit in
                if let recruitv2 = recruit {
                    createdRecruiters.append(recruitv2)
                }
                group.leave()
            }
            group.notify(queue: .main) { [] in
                completion(createdRecruiters)
            }
        }
    }
}
