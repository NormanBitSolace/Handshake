import SwiftUI

struct JobListView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.jobViewModels, id: \.id) { model in
                    NavigationLink(
                        destination:
                            JobDetailView(job: model)
                                .environmentObject(viewModel)
                        ,
                        label: {
                            JobRowView(model: model)
                        })
                }
            }
            .padding()
            .navigationTitle("Jobs")
        }
        .onAppear {
            viewModel.getJobsPublisher.send(())
        }
    }
 }
//
//struct JobListView_Previews: PreviewProvider {
//    static let app = AppLogic(service: TestApiService())
//    static var previews: some View {
//        NavigationView {
//            JobListView()
//                .environmentObject(app.viewModel)
//        }
//    }
//}
