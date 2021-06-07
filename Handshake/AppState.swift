import Combine

final class AppState: ObservableObject {
    @Published var jobs: [Job] = []
}
