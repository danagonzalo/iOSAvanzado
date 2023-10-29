import UIKit
import CoreData


// MARK: - View Protocol
protocol HeroesListViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var loginVieModel: LoginViewControllerDelegate { get set }
    var mapViewModel: MapViewControllerDelegate { get set }
    var heroesList: Heroes { get }
    
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate?
    func onLogoutPressed()
}


// MARK: - View State
enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
    case logOut
}


// MARK: - Class
class HeroesListViewController: UIViewController {
    
    // MARK: - Outlets y Actions
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBAction func onLogOutPressed() {
        viewModel?.viewState?(.logOut)
        performSegue(withIdentifier: "HEROES_LIST_TO_LOGIN", sender: nil)
    }
    
    @IBAction func onViewMapPressed(_ sender: Any) {
        performSegue(withIdentifier: "HEROES_LIST_TO_MAP", sender: nil)
        
    }
    
    
    // MARK: - Properties
    var viewModel: HeroesListViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "HEROES_LIST_TO_HERO_DETAIL" :
            guard let index = sender as? Int,
                  let heroDetailViewController = segue.destination as? HeroDetailViewController,
                  let detailViewModel = viewModel?.heroDetailViewModel(index: index) else {
                return
            }
            
            heroDetailViewController.viewModel = detailViewModel
            
        case "HEROES_LIST_TO_LOGIN":
            guard let loginViewController = segue.destination as? LoginViewController,
                  let loginViewModel = viewModel?.loginVieModel else {
                return
            }
            
            loginViewController.viewModel = loginViewModel
            
        case "HEROES_LIST_TO_MAP":
            guard let mapViewController = segue.destination as? MapViewController,
                  let mapViewModel = viewModel?.mapViewModel else {
                return
            }
            
            mapViewController.viewModel = mapViewModel
            
        default:
            break
        }
    }
    
    
    // MARK: - Private functions
    private func initViews() {
        tableView.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    
                case .updateData:
                    self?.tableView.reloadData()
                    
                case .logOut:
                    self?.viewModel?.onLogoutPressed()
                }
            }
        }
    }
}

// MARK: - Extensions: TableView Delegate/DataSource
extension HeroesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroCellView.estimatedHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCellView.identifier,
                                                       for: indexPath) as? HeroCellView else {
            return UITableViewCell()
        }

        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(name: hero.name, photo: hero.photo, description: hero.description)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HEROES_LIST_TO_HERO_DETAIL", sender: indexPath.row)
    }
}
