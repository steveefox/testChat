

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir(size: 20))
    
    let loginWithLabel = UILabel(text: "LoginWith", font: .avenir(size: 20))
    let orLabel = UILabel(text: "or", font: .avenir(size: 20))
    let emailLabel = UILabel(text: "Email", font: .avenir(size: 20))
    let passwordLabel = UILabel(text: "Password", font: .avenir(size: 20))
    let needAnAccountLabel = UILabel(text: "NeedAnAccount?", font: .avenir(size: 20))
    
    let googleButton = UIButton(title: "Google",
                            backgroundColor: .mainWhite(),
                            titleColor: .black,
                            isShadow: true)
    let loginButton = UIButton(title: "Login", backgroundColor: .buttonDark(), titleColor: .white)
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir(size:20)
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    let emailTextField = OneLineTextField(font: .avenir(size: 20))
    let passwordTextField = OneLineTextField(font: .avenir(size: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        
        setupConstraints()
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        signUpButton.addTarget(self,
                              action: #selector(signUpButtonTapped),
                              for: .touchUpInside)
        googleButton.addTarget(self,
                               action: #selector(googleButtonTapped),
                               for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        
        AuthService.shared.login(email: emailTextField.text!,
                                 password: passwordTextField.text!) { result  in
            
            switch result {
            case .success(let user ):
                self.showAlert(title: "Success", message: "You are authorize") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let myUser):
                            print(myUser)
                            let maintTabBarVC = MainTabBarController(currentUser: myUser)
                            maintTabBarVC.modalPresentationStyle = .fullScreen
                            self.present(maintTabBarVC, animated: true, completion: nil)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    @objc private func signUpButtonTapped() {
        
        dismiss(animated: true) {
            self.delegate?.toSignUpVc()
        }
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}





//MARK: -SetupConstraints
private extension LoginViewController {
    func setupConstraints() {
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel,passwordTextField],
                                            axis: .vertical,
                                            spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            loginWithView,
            orLabel,
            emailStackView,
            passwordStackView,
            loginButton
            ],
                                    axis: .vertical,
                                    spacing: 40)
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel,signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

//MARK: -SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewContoller = LoginViewController()
        
        func makeUIViewController(context: Context) -> LoginViewController {
            return viewContoller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
}
