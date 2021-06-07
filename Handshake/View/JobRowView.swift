import SwiftUI

struct JobRowView: View {
    let model: JobViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.title)")
                .font(.headline)
                .bold()
            Text("Salary: \(model.salary)")
                .font(.body)
            Text("Recuriter: \(model.recruiter.firstName) \(model.recruiter.lastName)")
                .font(.caption2)
           VStack(alignment: .leading) {
                Text("\(model.recruiter.emailAddress)")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.leading)
            Text("Employer: \(model.employer.name)")
                .font(.caption2)
           VStack(alignment: .leading) {
                Text("\(model.employer.address)")
                Text("\(model.employer.description)")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.leading)
        }
    }
}

struct JobRowView_Previews: PreviewProvider {
    static var previews: some View {
        JobRowView(model: JobViewModel.example)
    }
}
