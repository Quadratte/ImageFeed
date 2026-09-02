import Foundation

final class OAuth2Service {

    // MARK: - Errors
    private enum NetworkError: Error {
        case codeError
        case invalidRequest
        case noData
        case decodingError
    }

    static let shared = OAuth2Service()
    private init() { }

    private let tokenStorage = OAuth2TokenStorage()

    @MainActor

    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Invalid request")
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                print("HTTP error: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.codeError))
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)

                self?.tokenStorage.token = tokenResponse.accessToken
                
                print("Token saved")

                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }

        task.resume()
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.url) else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
