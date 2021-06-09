import Foundation
import Combine

final class AppLogic: ObservableObject {
    @Published var state: AppState
    @Published var viewModel: AppViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(service: NetworkApiService) {
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
                service.getJobs()
            }
            .store(in: &subscriptions)

        //  Listens for UI request to toggle a favorite and calls service.toggleFavorite
        viewModel.toggleFavoritePublisher
            .sink { favorite in
                service.toggleFavorite(favorite: favorite)
            }
            .store(in: &subscriptions)

        //  Listens for server updates on favorite and updates the view model
        service.updateFavoritePublisher
            .receive(on: DispatchQueue.main)
            .sink { favorite in
                print("Server sent Favorite with isFavorited = \(favorite.isFavorited)")
                if let index = self.viewModel.jobViewModels.firstIndex(where: { $0.id == favorite.jobId }) {
//                    self.viewModel.objectWillChange.send()
                    self.viewModel.jobViewModels[index] = self.viewModel.jobViewModels[index].setFavorite(favorite.isFavorited)
                        print("Job at index \(index) isFavorited = \(self.viewModel.jobViewModels[index].isFavorited)")
                    }
            }
            .store(in: &subscriptions)

        //  Listens for view model jobs changes and updates cache
        viewModel.$jobViewModels
            .filter { $0.count > 0 }
            .sink { jobViewModels in
                let jobs = jobViewModels.map { $0.job }
                service.cacheJobs(jobs: jobs)
            }
            .store(in: &subscriptions)
    }
}
