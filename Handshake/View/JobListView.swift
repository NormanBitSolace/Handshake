import SwiftUI

struct JobListView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        List {
            ForEach(viewModel.jobViewModels.indices, id: \.self) { index in
                let model: JobViewModel? = viewModel.jobViewModels[index]
                NavigationLink(
                    destination:
                        JobDetailView(job: $viewModel.jobViewModels[index])
                            .environmentObject(viewModel)
                    ,
                    label: {
                        JobRowView(model: $viewModel.jobViewModels[index])
                            .onAppear {
                                viewModel.requestJobsPublisher.send(model)
                            }
                    })
            }
            .padding()
            .navigationTitle("Jobs")
            if viewModel.isLoading {
                Text("Loading")
            }
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
