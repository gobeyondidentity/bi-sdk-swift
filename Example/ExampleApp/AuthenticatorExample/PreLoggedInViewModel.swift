import Foundation

struct PreLoggedInViewModel {
    let urlScheme = "acme"
    var cloudURL: URL {
        URL(string: "https://acme-cloud.rolling.byndid.run/start?redirect=\(urlScheme)://")!
    }
    let navigationTitle = "Log in with Beyond Identity"

    func createRequest(with email: String) -> URLRequest {
        let url = URL(string: "https://acme-cloud.byndid.com/enroll")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        request.httpBody = bodyData

        return request
    }

    func enroll(with email: String, _ callback: @escaping (Result<Data, Error>) -> Void) {
        enum NetworkError: Error {
            case error(Error)
            case missingResponse
            case missingData
            case server(statusCode: Int)
        }

        let webTask = URLSession.shared.dataTask(
            with: createRequest(with: email),
            completionHandler: { (data, response, error) in
            if let error = error {
                callback(.failure(NetworkError.error(error)))
            } else if response == nil {
                callback(.failure(NetworkError.missingResponse))
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                callback(.failure(NetworkError.server(statusCode: statusCode)))
            } else if let data = data {
                callback(.success(data))
            } else {
                callback(.failure(NetworkError.missingData))
            }
            })

        webTask.resume()
    }

}
