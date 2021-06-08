import SwiftUI

struct JobRowView: View {
    @State var model: JobViewModel
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 50)
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(model.title)")
                            .font(.title)
                            .font(.system(size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                        Spacer()

                        Image(systemName: model.isFavorited ? "star.fill" : "star")
                            .onTapGesture {
                                model.isFavorited.toggle()
                                viewModel.postJobFavoritePublisher.send(model)
                            }
                    }
                    Text("\(model.employer.name)")
                        .font(.headline)
                }

            }
            .padding()
        }
    }
}

struct JobRowView_Previews: PreviewProvider {
    static var previews: some View {
        JobRowView(model: JobViewModel.example)
    }
}
