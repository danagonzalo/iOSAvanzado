import Foundation

public typealias Heroes = [Hero]

public struct Hero: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case isFavorite = "favorite"
    }

    public let id: String?
    public let name: String?
    public let description: String?
    public let photo: String?
    public let isFavorite: Bool?
}
