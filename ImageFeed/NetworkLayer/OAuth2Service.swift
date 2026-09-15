import Foundation

final class OAuth2Service {

    // MARK: - Errors
    private enum NetworkError: Error {
        case codeError
        case invalidRequest
        case noData
        case decodingError
    }

    // MARK: - Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()

    private init() { }

    private let tokenStorage = OAuth2TokenStorage.shared

    @MainActor

    // MARK: - Fetch token
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            
            if lastCode == code {
                completion(.failure(NetworkError.codeError))
                return
            }
        }

        lastCode = code

        guard
            let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.codeError))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }

                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.tokenStorage.token = authToken
                    completion(.success(authToken))

                    self.task = nil
                    self.lastCode = nil

                case .failure(let error):
                    print("[fetchOAuthToken]: Ошибка запроса: \(error.localizedDescription)")
                    completion(.failure(error)) 

                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }

// MARK: - Make request
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.url) else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let authTokenUrl = urlComponents.url else { return nil }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
