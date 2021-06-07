import Foundation

enum NetworkError: Error {
    case encodeFailed, decodeFailed, unknownError, uploadFailed, notFound
    case system(String)
}
