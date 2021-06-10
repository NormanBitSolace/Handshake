import Combine

final class AppViewModel: ObservableObject {
    @Published var jobViewModels: [JobViewModel] = []
    @Published var isLoading = false
    let getJobsPublisher = PassthroughSubject<Void, Never>()
    let toggleFavoritePublisher = PassthroughSubject<Favorite, Never>()
    let requestJobsPublisher = PassthroughSubject<JobViewModel?, Never>()
}
