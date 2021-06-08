import SwiftUI

struct JobListView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var isEditing = false

    var body: some View {
        List {
            ForEach(viewModel.jobViewModels, id: \.id) { model in
                JobRowView(model: model)
                    .onTapGesture {
                        isEditing = true
                        viewModel.showUpdateJobPublisher.send(model)
                    }
            }
            .onDelete(perform: removeItems)
            .padding()
        }
        .padding()
        .navigationTitle("Jobs")
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $viewModel.showCreateJob, content: {
            if let createJobViewModel = viewModel.createJobViewModel {
                NavigationView {
                    CreateJobView(isEditing: isEditing)
                        .environmentObject(createJobViewModel)
                }
            }
        })
    }
    
    private var addButton: some View {
        Button(action: {
            viewModel.showCreateJobPublisher.send(())
        }, label: {
            Image(systemName: "plus")
        })
    }

    private func removeItems(at offsets: IndexSet) {
        //  TODO remove from viewModel.jobViewModels and subscribe to those changes to update backend e.g. viewModel.jobViewModels.remove(atOffsets: offsets)
        for offset in offsets {
            let model = viewModel.jobViewModels[offset]
            viewModel.deleteJobPublisher.send(model.id)
        }
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
