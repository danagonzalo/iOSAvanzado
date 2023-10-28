import UIKit
import CoreData
import MapKit


// MARK: - Protocol
protocol MapViewControllerDelegate {
    var heroLocationsList: HeroLocations { get }
    var viewState: ((MapViewState) ->  Void)? { get set }
    func onViewAppear()
}
    

// MARK: - View State
enum MapViewState {
    case loading(_ isLoading: Bool)
    case loadData(hero: Hero, locations: HeroLocations)
}


// MARK: - Class
class MapViewController: UIViewController {
    
    // MARK: - IBOutlets and IBActions
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Properties
    var viewModel: MapViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    // MARK: - Private functions
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    print("Loading map...")
                    // TODO: self?.loadingView.isHidden = !isLoading
                case .loadData(let hero, let heroLocations):
                    self?.updateViews(hero: hero, heroLocation: heroLocations)
                }
            }
        }
    }
        
    private func updateViews(hero: Hero, heroLocation: HeroLocations) {
        for location in heroLocation {
            getLocations(hero: hero, location: location)
        }
    }
        
    private func getLocations(hero: Hero, location: HeroLocation) {
        mapView.addAnnotation(
            HeroAnnotation(
                title: hero.name,
                info: hero.id,
                coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0,
                                  longitude: Double(location.longitude ?? "") ?? 0.0)
            )
        )
    }
}
    
    // TODO: Make add Location to map func
//    private func addToMap(location: LocationDAO) {
//        
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
