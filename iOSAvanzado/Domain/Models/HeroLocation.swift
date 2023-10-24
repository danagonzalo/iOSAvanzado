import Foundation

typealias HeroLocations = [HeroLocation]

struct HeroLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
        case hero
    }

    let id: String?
    let latitude: String?
    let longitude: String?
    let date: String?
    let hero: Hero?
}
