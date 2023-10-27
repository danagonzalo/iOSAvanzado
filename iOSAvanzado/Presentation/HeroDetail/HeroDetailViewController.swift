import UIKit
import MapKit
import Kingfisher

// MARK: - Protocol
protocol HeroDetailViewControllerDelegate {
    var viewState: ((HeroDetailViewState) -> Void)? { get set }
    
    func onViewAppear()
}

// MARK: - View state
enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

// MARK: - Class
class HeroDetailViewController: UIViewController {
    // MARK: - Outlets and actions
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UITextView!

    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Properties
    var viewModel: HeroDetailViewControllerDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewAppear()
    }

    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        // TODO: self?.loadingView.isHidden = !isLoading
                        break

                    case .update(let hero, let locations):
                        self?.updateViews(hero: hero, heroLocations: locations)
                }
            }
        }
    }

    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        photo.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: photo)

        name.text = hero?.name
        heroDescription.text = hero?.description

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
    }

    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}

//MARK: — MKMapView Delegate Methods
extension HeroDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "HeroAnnotation"
        let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        ) ?? MKAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier
        )

        annotationView.canShowCallout = true
        if annotation is MKUserLocation {
            return nil
        } else if annotation is HeroAnnotation {
            // Resize image
            let pinImage = UIImage(named: "img_map_pin")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            annotationView.image = resizedImage
            return annotationView
        } else {
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let heroAnnotation = view.annotation as? HeroAnnotation else { return }
    }
}
