import SwiftUI

struct ContentView: View {
    let service: ApiService
    @StateObject var app: AppLogic

    init() {
        service = NetworkApiService()
        let app = AppLogic(service: service)
        _app = StateObject(wrappedValue: app)
    }

    var body: some View {
        NavigationView {
            JobListView()
                .environmentObject(app.viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
