import Foundation

final class JsonApi {

    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.system(error.localizedDescription)))
                return
            }
            if let data = data {
                if let model = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(model))
                } else {
                    completion(.failure(.decodeFailed))
                }
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
    }

    private func upload<Input: Encodable, Output: Decodable>(url: URL, model: Input, method: String = "POST", completion: @escaping (Result<Output, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONEncoder().encode(model) else {
            completion(.failure(.encodeFailed))
            return
        }
        request.httpBody = data
        request.httpMethod = method
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.system(error.localizedDescription)))
                return
            }
            if let data = data {
                if let model = try? JSONDecoder().decode(Output.self, from: data) {
                    completion(.success(model))
                } else {
                    completion(.failure(.decodeFailed))
                }
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
    }

    func post<Input: Encodable, Output: Decodable>(url: URL, model: Input, completion: @escaping (Result<Output, NetworkError>) -> Void) {
        upload(url: url, model: model, completion: completion)
    }

    func put<Input: Encodable, Output: Decodable>(url: URL, model: Input, completion: @escaping (Result<Output, NetworkError>) -> Void) {
        upload(url: url, model: model, method: "PUT", completion: completion)
    }

    func delete(url: URL, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.system(error.localizedDescription)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 300 {
                    completion(.success(()))
                } else {
                    completion(.failure(.system(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))))
                }
            }
        }.resume()
    }
}
