import SwiftUI

struct CreateJobView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var createJobViewModel: CreateJobViewModel
    @Environment(\.presentationMode) var presentationMode
    let isEditing: Bool

    var body: some View {
        Form {
            Section(header: Text("Enter Job Info")) {
                HStack {
                    Text("Title")
                    Spacer()
                    TextField("Title", text: $createJobViewModel.titleText)
                }
                HStack {
                    Text("Salary")
                    Spacer()
                    TextField("Salary", text: $createJobViewModel.salaryText)
                        .keyboardType(.decimalPad)
                }
                Picker("Employer", selection: $createJobViewModel.employerText) {
                    ForEach(createJobViewModel.employerNames, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Recruiter", selection: $createJobViewModel.recruiterText) {
                    ForEach(createJobViewModel.recruiterNames, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Update Job" : "Create Job")
        .navigationBarItems(trailing: saveButton)
    }


    private var saveButton: some View {
        Button(action: {
            if let job = createJobViewModel.job {
                if isEditing {
                    viewModel.updateJobPublisher.send(job)
                } else {
                    viewModel.createJobPublisher.send(job)
                }
            }
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
        .disabled(createJobViewModel.incompleteForm)
    }
}


struct CreateJobView_Previews: PreviewProvider {
    static let app = AppLogic(service: TestApiService())
    static var previews: some View {
        let jobs: [Job] = [
            Job(id: 1, title: "Rock Star", salary: 1000000.00, employer: Employer(name: "Big Deal", address: "123 Main Street", description: "When you want to be a big deal, this is the place!"), recruiter: Recruiter(firstName: "Wanda", lastName: "Sykes", email: "sykes@icloud.com"))
        ]
        let employers = jobs.map { $0.employer }
        let recruiters = jobs.map { $0.recruiter }
        app.viewModel.createJobViewModel = CreateJobViewModel(employers: employers, recruiters: recruiters)
        return NavigationView {
            CreateJobView(isEditing: false)
                .environmentObject(app.viewModel)
                .environmentObject(app.viewModel.createJobViewModel!)
        }
    }
}
