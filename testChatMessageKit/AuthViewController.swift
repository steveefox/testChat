//
//  ViewController.swift
//  testChatMessageKit
//
//  Created by Nikita on 31.01.21.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        googleButton.customizeGoogleButton()
        
        setupConstraints()
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
