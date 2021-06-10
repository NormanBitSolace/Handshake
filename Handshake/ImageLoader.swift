import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
    }

    deinit {
        cancel()
    }

    func load() {
        guard let url = url else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

struct MyAsyncImage: View {
    let url: URL?
    @StateObject var loader: MyImageLoader

    init(url: URL?) {
        self.url = url
        _loader = StateObject(wrappedValue: MyImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
//            .onAppear {
//                loader.load()
//            }
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "photo")
                    .resizable()
            }
        }
    }
}

class MyImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
    }

    deinit {
        cancel()
    }

    func load() {
        guard let url = url else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}
