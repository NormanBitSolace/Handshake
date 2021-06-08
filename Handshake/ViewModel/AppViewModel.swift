import Combine

final class AppViewModel: ObservableObject {
    @Published var jobViewModels: [JobViewModel] = []
    let showCreateJobPublisher = PassthroughSubject<Void, Never>()
    let showUpdateJobPublisher = PassthroughSubject<JobViewModel, Never>()
    let createJobPublisher = PassthroughSubject<Job, Never>()
    let updateJobPublisher = PassthroughSubject<Job, Never>()
    let deleteJobPublisher = PassthroughSubject<Int, Never>()
    @Published var showCreateJob = false
    @Published var createJobViewModel: CreateJobViewModel?
}
