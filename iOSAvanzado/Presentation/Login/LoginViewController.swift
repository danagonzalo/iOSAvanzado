import UIKit

// MARK: - View Protocol
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    var heroesViewModel: HeroesListViewControllerDelegate { get }
    func onLoginPressed(email: String?, password: String?)
}

// MARK: - View State
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    // MARK: - IBOutlets and IBActions
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var loadingView: UIView!

    @IBAction func onLoginPressed() {
        viewModel?.onLoginPressed(email: emailField.text, password: passwordField.text)
    }

    // MARK: - Properties
    var viewModel: LoginViewControllerDelegate?

    private enum FieldType: Int {
        case email = 0
        case password
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        setObservers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "LOGIN_TO_HEROES_LIST",
              let heroesViewController = segue.destination as? HeroesListViewController else {
            return
        }

        heroesViewController.viewModel = viewModel?.heroesViewModel
    }

    // MARK: - Private functions
    private func initViews() {
        emailField.delegate = self
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        )
    }

    @objc func dismissKeyboard() {
        // Ocultar el teclado al pulsar en cualquier punto de la vista
        view.endEditing(true)
    }

    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading

                    case .showErrorEmail(let error):
                        self?.emailFieldError.text = error
                        self?.emailFieldError.isHidden = (error == nil || error?.isEmpty == true)

                    case .showErrorPassword(let error):
                        self?.passwordFieldError.text = error
                        self?.passwordFieldError.isHidden = (error == nil || error?.isEmpty == true)

                    case .navigateToNext:
                        self?.performSegue(withIdentifier: "LOGIN_TO_HEROES_LIST", sender: nil)
                }
            }
        }
    }
}

// MARK: - Extension
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
            case .email:
                emailFieldError.isHidden = true

            case .password:
                passwordFieldError.isHidden = true

            default: break
        }
    }
}
