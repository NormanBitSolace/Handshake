import Combine

final class AppViewModel: ObservableObject {
    @Published var jobViewModels: [JobViewModel] = []
    let getJobsPublisher = PassthroughSubject<Void, Never>()
}
