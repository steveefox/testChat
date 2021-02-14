//
//  UserCell.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "UserCell"
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text:  "text", font: UIFont.laoSangamMN(size: 20))
    let containerView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil 
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let myUser = value as? MyUser else { return }
        userNameLabel.text = myUser.username
        guard let url = URL(string: myUser.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView .bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView .heightAnchor.constraint(equalTo:  containerView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    
}



//MARK: -SwiftUI
import SwiftUI

struct UserCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewContoller = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return viewContoller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
}
