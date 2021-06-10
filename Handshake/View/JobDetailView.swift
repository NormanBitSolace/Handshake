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
                Spacer()
                Image(systemName: job.isFavorited ? "star.fill" : "star")
                    .onTapGesture {
                        viewModel.toggleFavoritePublisher.send(job.favorite)
                    }
            }
            .font(.title)
            .padding(.bottom)
            Text(job.salary)
                .font(.body)
                .padding(.bottom)
            Text(job.employer.name)
                .bold()
                .padding(.bottom)
            Text(job.employer.address)
                .font(.caption)
                .padding(.bottom)
            ScrollView {
                Text(job.employer.description)
                    .font(.caption)
            }
            HStack {
                Text(job.recruiter.firstName)
                Text(job.recruiter.lastName)
                Text(job.recruiter.emailAddress)
                    .underline()
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
