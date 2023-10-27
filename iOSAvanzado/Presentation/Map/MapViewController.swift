import UIKit
import MapKit


// MARK: - Protocol
protocol MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)? { get set }
    var heroesList: Heroes { get }
}
    

// MARK: - View State
enum MapViewState {
    case loading(_ isLoading: Bool)
    case updateData
}


// MARK: - Class
class MapViewController: UIViewController {
    
    // MARK: - IBOutlets and IBActions
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
//        performSegue(withIdentifier: "MAP_TO_HEROES_LIST", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    var viewModel: MapViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
//        for hero in viewModel?.heroesList {
//            ApiProvider.shared.getLocations(for: hero.id, token: SecureDataProvider.shared.getToken() ?? "") { locations in
//                print("Locations: \(locations)")
//            }
//        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "MAP_TO_HEROES_LIST",
//              let heroesListViewController = segue.destination as? HeroesListViewController else {
//            return
//        }
//
//        heroesListViewController.viewModel = viewModel?.heroesListViewModel
//    }
}
        
        
        
//        heroLocations.forEach {
//            mapView.addAnnotation(
//                HeroAnnotation(
//                    title: hero?.name,
//                    info: hero?.id,
//                    coordinate: .init(latitude: Double($0.latitude ?? "") ?? 0.0,
//                                      longitude: Double($0.longitude ?? "") ?? 0.0)
//                )
//            )
//        }
//    }



//MARK: — MKMapView Delegate Methods
//extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "HeroAnnotation"
//        let annotationView = mapView.dequeueReusableAnnotationView(
//            withIdentifier: identifier
//        ) ?? MKAnnotationView(
//            annotation: annotation,
//            reuseIdentifier: identifier
//        )
//
//        annotationView.canShowCallout = true
//        if annotation is MKUserLocation {
//            return nil
//        } else if annotation is HeroAnnotation {
//            // Resize image
//            let pinImage = UIImage(named: "img_map_pin")
//            let size = CGSize(width: 30, height: 30)
//            UIGraphicsBeginImageContext(size)
//            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//            annotationView.image = resizedImage
//            return annotationView
//        } else {
//            return nil
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let heroAnnotation = view.annotation as? HeroAnnotation else { return }
////        coordinates.text = "Last coordinates: \(heroAnnotation.coordinate.latitude), \(heroAnnotation.coordinate.longitude)"
//    }
//}
