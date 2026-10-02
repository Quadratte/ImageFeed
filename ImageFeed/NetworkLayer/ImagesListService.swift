import Foundation
internal import CoreGraphics

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

struct LikeResult: Codable {
    let photo: PhotoResult
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImagesListService {
    static let shared = ImagesListService(); private init() { }
    private(set) var photos: [Photo] = []

    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")

    private var lastLoadedPage: Int?
    private let perPage = 10

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    private lazy var dateFormatter: ISO8601DateFormatter = {
            ISO8601DateFormatter()
        }()

    func cleanPhotos() {
        photos = []
    }

    func fetchPhotosNextPage() {
        guard task == nil else { return }

        let nextPage = (lastLoadedPage ?? 0) + 1

        guard let token = OAuth2TokenStorage.shared.token else { return }
        guard let request = makePhotosRequest(page: nextPage, perPage: perPage, token: token) else { return }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                defer { self.task = nil }

                switch result {
                case .success(let results):
                    self.lastLoadedPage = nextPage
                    self.photos.append(contentsOf: results.map { self.convert(from: $0) })
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                case .failure(let error):
                    print("[ImagesListService]: \(error.localizedDescription)")
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func makePhotosRequest(page: Int, perPage: Int, token: String) -> URLRequest? {
        guard var comps = URLComponents(string: "https://api.unsplash.com/photos") else { return nil }
        comps.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        guard let url = comps.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func convert(from result: PhotoResult) -> Photo {
            Photo(
                id: result.id,
                size: CGSize(width: result.width, height: result.height),
                createdAt: result.createdAt.flatMap { dateFormatter.date(from: $0) },
                welcomeDescription: result.description,
                thumbImageURL: result.urls.thumb,
                largeImageURL: result.urls.full,
                isLiked: result.likedByUser
            )
        }

    // MARK: - Change Like
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike, token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(()))
                case .failure(let error):
                    print("[changeLike]: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func makeLikeRequest(photoId: String, isLike: Bool, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
