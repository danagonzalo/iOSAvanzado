import UIKit
import CoreData

// MARK: - View Protocol
protocol HeroesListViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var loginVieModel: LoginViewControllerDelegate { get set }
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
    
    // Referencia al managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading
                        
                    case .updateData:
                        self?.fetchHeroes()
                        self?.tableView.reloadData()
                    
                    case .logOut:
                        self?.viewModel?.onLogoutPressed()
                }
            }
        }
    }
}


// MARK: - Extensions: CoreData
extension HeroesListViewController {
    
    func fetchHeroes() {
        print("Fetching heroes count: \(viewModel!.heroesList.count)")
        for hero in viewModel!.heroesList {
            print("-- Hero found: \(String(describing: hero.name))")
            let newHero = HeroDAO(context: self.context)
            
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.longDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.isFavorite ?? false
            
            print("NEWHERO: \(String(describing: newHero.name))")
        }
        
        try? self.context.save()
        tableView.reloadData()
    }
}
    


// MARK: - Extensions: Delegate, DataSource
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
