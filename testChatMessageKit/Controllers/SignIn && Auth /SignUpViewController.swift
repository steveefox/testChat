//
//  SignUpViewController.swift
//  testChatMessageKit
//
//  Created by Nikita on 2.02.21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    let welcomeLabel = UILabel(text: "Hello!", font: .avenir(size: 26))
    
    let emailLabel = UILabel(text: "Email", font: .avenir(size: 26))
    let passwordLabel = UILabel(text: "Passwod", font: .avenir(size: 26))
    let confirmPasswordLabel = UILabel(text: "Confirm password", font: .avenir(size: 26))
    let alreadyOnBoardLabel = UILabel(text: "Already onboard ?", font: .avenir(size: 26))
    
    let emailTextField = OneLineTextField(font: .avenir(size: 20))
    let passwordTextField = OneLineTextField(font: .avenir(size: 20))
    let confirmPasswordTextFiled = OneLineTextField(font: .avenir(size: 20))

    let signUpButton = UIButton(title: "Sign up", backgroundColor: .buttonDark(), titleColor: .white, cornerRadius: 4)
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir(size:20)
        return button
    }()
    
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        view.backgroundColor = .white
        
        signUpButton.addTarget(self,
                               action: #selector(signUpButtonTapped),
                               for: .touchUpInside)
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
    }
    
    
    @objc private func signUpButtonTapped() {
        
        AuthService.shared.register(email: emailTextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordTextFiled.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Success", message: "You are register") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                }
                
            case .failure(let error):
                self.showAlert(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toLoginVc()
        }
    }
}


//MARK: -ShowAlert
extension UIViewController {
    
    func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        
        
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
}



//MARK: -SetupConstraints
private extension SignUpViewController {
    func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPassworlStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextFiled], axis: .vertical, spacing: 0)
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPassworlStackView, signUpButton], axis: .vertical, spacing: 40)
        
        loginButton.contentHorizontalAlignment = .left
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnBoardLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
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

struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewContoller = SignUpViewController()
        
        func makeUIViewController(context: Context) -> SignUpViewController {
            return viewContoller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
}

