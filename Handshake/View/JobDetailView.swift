import SwiftUI

struct JobDetailView: View {
    @Binding var job: JobViewModel
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: job.employerImage)
                .frame(height: 100)
            HStack {
                Text(job.title)
                    .accessibilityLabel("Title")
                Spacer()
                Image(systemName: job.isFavorited ? "star.fill" : "star")
                    .accessibilityLabel(job.isFavorited ? "Favorite" : "Not favorite")
                    .onTapGesture {
                        viewModel.toggleFavoritePublisher.send(job.favorite)
                    }
            }
            .font(.title)
            .padding(.bottom)
            Text(job.salary)
                .font(.body)
                .accessibilityLabel("Salary")
                .padding(.bottom)
            Text(job.employer.name)
                .bold()
                .accessibilityLabel("Employer name")
                .padding(.bottom)
            Text(job.employer.address)
                .font(.caption)
                .accessibilityLabel("Employer address")
                .padding(.bottom)
            ScrollView {
                Text(job.employer.description)
                    .font(.caption)
                    .accessibilityLabel("Employer description")
            }
            HStack {
                Text(job.recruiter.firstName)
                    .accessibilityLabel("Recruiter first name")
                Text(job.recruiter.lastName)
                    .accessibilityLabel("Recruiter last name")
                Text(job.recruiter.emailAddress)
                    .underline()
                    .accessibilityLabel("Recruiter email address")
            }
            .font(.caption)
        }
        .padding(.horizontal)
    }
}


struct JobDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JobDetailView(job: .constant(JobViewModel.example))
    }
}
