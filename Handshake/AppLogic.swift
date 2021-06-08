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
            .assign(to: \.state.jobs, on: self)
            .store(in: &subscriptions)

        //  Listen for state.jobs changes and update view model
        state.$jobs
            .receive(on: DispatchQueue.main)
            .map { $0.map { JobViewModel(model: $0) }.sorted { $0.title < $1.title } }
            .assign(to: \.viewModel.jobViewModels, on: self)
            .store(in: &subscriptions)

        //  Listens for a UI request for to show create new Job sheet
        viewModel.showCreateJobPublisher
            .sink { [self] in
                self.viewModel.createJobViewModel = CreateJobViewModel(employers: self.state.jobs.uniqueEmployers, recruiters: self.state.jobs.uniqueRecruiters)
                self.viewModel.showCreateJob = true
            }
            .store(in: &subscriptions)

        //  Listens for a UI request for to show update Job sheet
        viewModel.showUpdateJobPublisher
            .sink { job in
                self.viewModel.createJobViewModel = CreateJobViewModel(employers: self.state.jobs.uniqueEmployers, recruiters: self.state.jobs.uniqueRecruiters, job: job)
                self.viewModel.showCreateJob = true
            }
            .store(in: &subscriptions)

        //  Listens for a UI request to create a new Job
        viewModel.createJobPublisher
            .sink { job in
                self.service?.createJob(job) {
                    self.service?.getJobs()
                }
            }
            .store(in: &subscriptions)

        //  Listens for a UI request to update a Job
        viewModel.updateJobPublisher
            .sink { job in
                self.service?.updateJob(job) {
                    self.service?.getJobs()
                }
            }
            .store(in: &subscriptions)

        //  Listens for a UI request to delete a Job
        viewModel.deleteJobPublisher
            .sink { id in
                self.service?.deleteJob(id: id) {
                    self.service?.getJobs()
                }
            }
            .store(in: &subscriptions)

        service.getJobs()
    }
}
