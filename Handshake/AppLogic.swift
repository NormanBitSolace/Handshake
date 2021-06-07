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
}
