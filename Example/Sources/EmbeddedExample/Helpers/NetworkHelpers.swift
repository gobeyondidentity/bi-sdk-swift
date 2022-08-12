import BeyondIdentityEmbedded
import Foundation
import UIKit

func createOktaTokenRequest(with baseURL: URL, code: String, code_verifier: String) -> URLRequest {
    var request = URLRequest(url: baseURL)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let parameters = "grant_type=authorization_code&code_verifier=\(code_verifier)&code=\(code)"
    let postData =  parameters.data(using: .utf8)
    
    request.httpBody = postData
    return request
}

func createAuth0TokenRequest(with config: Auth0Config, code: String, code_verifier: String) -> URLRequest {
    var request = URLRequest(url: config.tokenBaseURL)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let parameters = "grant_type=authorization_code&client_id=q1cubQfeZWnajq5YkeZVD3NauRqU4vNs&code_verifier=\(code_verifier)&code=\(code)&redirect_uri=acme%3A%2F%2Fdev"
    let postData =  parameters.data(using: .utf8)
    
    request.httpBody = postData
    return request
}

func handleTokenResponse(data: Data, callback: @escaping (String) -> Void) {
    let response = try? JSONDecoder().decode(TokenResponse.self, from: data)
    guard let response = response else {
        callback("Error decoding TokenResponse")
        return
    }
    callback(response.description)
}

func parseParameter(from url: URL, for param: String) -> String? {
    guard let url = URLComponents(string: url.absoluteString) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
}

func createBindRequest(for username: String, with url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = [
        "username": username,
        "authenticator_type" : "native",
        "delivery_method": "return"
    ]
    
    request.httpBody = try? JSONSerialization.data(
        withJSONObject: body,
        options: []
    )
    
    return request
}

func handleBindRequest(data: Data, callback: @escaping (String) -> Void){
    let response = try? JSONDecoder().decode(BindResponse.self, from: data)
    let url = URL(string: response?.credentialBindingLink ?? "")
    if let url = url {
        Embedded.shared.bindCredential(url: url) { result in
            switch result {
            case let .success(response):
                callback(response.credential.description)
            case let .failure(error):
                callback(error.localizedDescription)
            }
        }
    }
}

func sendRequest(
    for vc: UIViewController,
    with request: URLRequest,
    callback: @escaping (Data) -> Void
) {
    let webTask = URLSession.shared.dataTask(
        with: request,
        completionHandler: { (data, response, error) in
            var message: String?
            
            if let error = error {
                message = error.localizedDescription
            } else if response == nil {
                message = "Error: response is nil"
            } else if let data = data {
                if let error = try? JSONDecoder().decode(DataError.self, from: data) {
                    message = error.message
                }else {
                    DispatchQueue.main.async {
                        callback(data)
                    }
                }
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                message = "Error: got status code \(statusCode)"
            } else {
                message = "Error: missing data"
            }
            
            if let message = message {
                DispatchQueue.main.async {
                    let dialog = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    dialog.addAction(action)
                    vc.present(dialog, animated: true, completion: nil)
                }
            }
        })
    
    webTask.resume()
}

struct BindResponse: Decodable {
    let credentialBindingLink: String
    
    enum CodingKeys: String, CodingKey {
        case credentialBindingLink = "credential_binding_link"
    }
}

struct DataError: Codable {
    let code: String
    let message: String
}

struct TokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let idToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope = "scope"
        case idToken = "id_token"
    }
}

extension TokenResponse: CustomStringConvertible {
    public var description: String {
        """
        tokenType: \(tokenType)
        expiresIn: \(expiresIn)
        scopes: \(scope)
        accessToken: \(accessToken)
        idToken: \(idToken)
        """
    }
}
