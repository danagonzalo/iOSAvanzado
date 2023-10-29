import Foundation
import iOSAvanzado

class MockApiService {
    
    private let responseDataHeroes: [[String: Any]] = [
        [
            "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
            "name": "Goku",
            "description": "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
            "favorite": false
        ],
        [
            "id": "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
            "name": "Vegeta",
            "description": "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.",
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
            "favorite": false
        ]
    ]
    
    private let responseDataHeroLocations: [[String: Any]] = [
            [
                "hero": ["id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"],
                "id": "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC",
                "latitud": "35.71867899343361",
                "longitud": "139.8202084625344",
                "dateShow": "2022-02-20T00:00:00Z",
            ],
            [
                "hero": ["id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"],
                "id": "2D83941D-3F84-458C-8A24-704E59D5FAEB",
                "latitud": "139.8202084625344",
                "longitud": "35.71867899343361",
                "dateShow": "2023-01-07T00:00:00Z",
            ],
            [
                "hero": ["id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"],
                "id": "17707388-B06F-4889-9DFC-C9F025508030",
                "latitud": "139.8202084625344",
                "longitud": "35.71867899343361",
                "dateShow": "2023-01-10T00:00:00Z",
            ],
            [
                "hero": ["id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"],
                "id": "DF243536-4F4F-4350-A6A4-046AC3847EA6",
                "latitud": "38.8202084625344",
                "longitud": "-77.036",
                "dateShow": "2023-01-10T00:00:00Z",
            ],
            [
                "hero": ["id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"],
                "id": "C2BF93D8-9158-4D72-8669-98ED67CA1B51",
                "latitud": "38.8202084625344",
                "longitud": "-77.036",
                "dateShow": "2023-01-12T00:00:00Z",
            ],
    ]
    

}

// MARK: - Protocol
extension MockApiService: ApiProviderProtocol {
    func login(for user: String, with password: String, completion: @escaping ((Result<String, iOSAvanzado.NetworkError>) -> Void)) {}
    
    func getHeroes(by name: String, completion: ((iOSAvanzado.Heroes) -> Void)?) {
        guard let data = try? JSONSerialization.data(withJSONObject: responseDataHeroes) else { return }
        let heroes = try? JSONDecoder().decode(Heroes.self, from: data)
        
        if name.isEmpty {
            completion?(heroes ?? [])
        } else {
            completion?(heroes?.filter { $0.name == name } ?? [])
        }
    }
    
    func getLocations(for heroId: String, completion: ((iOSAvanzado.HeroLocations) -> Void)?) {
        guard let data = try? JSONSerialization.data(withJSONObject: responseDataHeroLocations) else { return }
        guard let locations = try? JSONDecoder().decode(HeroLocations.self, from: data) else { return }
        
        if heroId != "D13A40E5-4418-4223-9CE6-D2F9A28EBE94" {
            completion?([])
        } else {
            completion?(locations)
        }
    }
}
