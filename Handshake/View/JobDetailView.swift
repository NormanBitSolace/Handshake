import SwiftUI

struct JobDetailView: View {
    @State var job: JobViewModel
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "photo")
                .resizable()
                .frame(height: 100)
            HStack {
                Text(job.title)
                Spacer()
                Image(systemName: job.isFavorited ? "star.fill" : "star")
                    .onTapGesture {
                        job.isFavorited.toggle()
                        viewModel.postJobFavoritePublisher.send(job)
                    }
            }
            .font(.title)
            .padding(.bottom)
            Text(job.salary)
                .font(.body)
                .padding(.bottom)
            Text(job.employer.name)
            Text(job.employer.address)
                .padding(.bottom)
            Text(job.employer.description)
            Text(job.recruiter.firstName)
        }
//        .onReceive(location.$heading, perform: { heading in
//            withAnimation(.easeInOut(duration: 1.0)) {
//                self.angle = heading
//            }
//        })
    }
}


struct JobDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JobDetailView(job: JobViewModel.example)
    }
}
