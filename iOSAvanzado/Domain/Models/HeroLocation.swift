import Foundation

public typealias HeroLocations = [HeroLocation]

public struct HeroLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
        case hero
    }

    public let id: String?
    public let latitude: String?
    public let longitude: String?
    public let date: String?
    public let hero: Hero?
}
