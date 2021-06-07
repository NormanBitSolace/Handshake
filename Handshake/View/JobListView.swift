import SwiftUI

struct JobListView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.jobViewModels, id: \.id) { model in
                    JobRowView(model: model)
                }
            }
            .padding()
            .navigationTitle("Jobs")
            .navigationBarItems(trailing: fetchButton)
        }
    }
    
    private var fetchButton: some View {
        Button(action: {
            viewModel.getJobsPublisher.send(())
        }, label: {
            Image(systemName: "goforward")
        })
    }
}

struct JobListView_Previews: PreviewProvider {
    static let app = AppLogic(service: TestApiService())
    static var previews: some View {
        NavigationView {
            JobListView()
                .environmentObject(app.viewModel)
        }
    }
}
