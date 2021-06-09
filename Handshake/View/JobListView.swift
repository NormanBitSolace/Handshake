import SwiftUI

struct JobListView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        List {
            ForEach(viewModel.jobViewModels.indices, id: \.self) { index in
                NavigationLink(
                    destination:
                        JobDetailView(job: $viewModel.jobViewModels[index])
                            .environmentObject(viewModel)
                    ,
                    label: {
                        JobRowView(model: $viewModel.jobViewModels[index])
                    })
            }
            .padding()
            .navigationTitle("Jobs")
        }
        .onAppear {
            viewModel.getJobsPublisher.send(())
        }
    }
}

struct JobListView_Previews: PreviewProvider {
    static let app = AppLogic(service: NetworkApiService())
    static var previews: some View {
        NavigationView {
            JobListView()
                .environmentObject(app.viewModel)
        }
    }
}
