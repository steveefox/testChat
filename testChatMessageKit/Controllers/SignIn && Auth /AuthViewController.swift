//
//  ViewController.swift
//  testChatMessageKit
//
//  Created by Nikita on 31.01.21.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get start with")
    let emailLabel = UILabel(text: "Or sign with")
    let alreadyOnBoardleLabel = UILabel(text: "Already onboard ?")
    
    let googleButton = UIButton(title: "Google",
                            backgroundColor: .mainWhite(),
                            titleColor: .black,
                            isShadow: true)
    let emailButton = UIButton(title: "Email",
                            backgroundColor: .buttonDark(),
                            titleColor: .white)
    
    let loginButton = UIButton(title: "Login",
                               backgroundColor: .mainWhite(),
                            titleColor: .buttonRed(),
                            isShadow: true)
    
    let signUpViewController = SignUpViewController()
    let loginViewController = LoginViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        googleButton.customizeGoogleButton()
        
        setupConstraints()
        signUpViewController.delegate = self
        loginViewController.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        emailButton.addTarget(self,
                              action: #selector(emailButtonTapped),
                              for: .touchUpInside)
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        googleButton.addTarget(self,
                               action: #selector(googleButtonTapped),
                               for: .touchUpInside)
    }

    @objc private func emailButtonTapped() {
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        present(loginViewController, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
 
}


//MARK: -AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
    
    func toLoginVc() {
        present(loginViewController, animated: true, completion: nil)
    }
    
    func toSignUpVc() {
        present(signUpViewController, animated: true, completion: nil)
    }
}


//MARK: GoogleSignInDelegate
extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shared.googleLogin(user: user, error: error) { result  in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let myUser):
                        UIApplication.getTopViewController()?.showAlert(title: "Успешно!", message: "Вы авторизованы") {
                            let mainTabBarVC = MainTabBarController(currentUser: myUser)
                            mainTabBarVC.modalPresentationStyle = .fullScreen
                            UIApplication.getTopViewController()?.present(mainTabBarVC, animated: true, completion: nil)
                        }
                    case .failure(_):
                        UIApplication.getTopViewController()?.showAlert(title: "Успешно!", message: "Вы зарегестированы") {
                            UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(_):
                UIApplication.getTopViewController()?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

//MARK: -SetupConstraints
private extension AuthViewController {
    func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnBoardleLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                               constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
    
}


//MARK: -SwiftUI
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewContoller = AuthViewController()
        
        func makeUIViewController(context: Context) -> AuthViewController {
            return viewContoller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
}
