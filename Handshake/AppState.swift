import Combine

final class AppState: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var jobsv2: [Jobv2] = []
}
