//
//  ActiveChatCell.swift
//  testChatMessageKit
//
//  Created by Nikita on 7.02.21.
//

import UIKit



class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    

    static var reuseId: String = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel(text: "User name", font: UIFont.laoSangamMN(size: 20))
    let lastMessageLabel = UILabel(text: "How are you ?", font: UIFont.laoSangamMN(size: 17))
    let gradientView = GradientView(from: .topTrailing,
                                    to: .bottomLeading,
                                    startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1),
                                    endColor: #colorLiteral(red: 0.4784313725, green: 0.6901960784, blue: 0.9215686275, alpha: 1))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure<U>(with value: U) where U : Hashable {
        guard let value = value as? MyChat else { return }
        friendImageView.image = UIImage(named: value.friendAvatarStringURL)
        friendNameLabel.text = value.friendUsername
        lastMessageLabel.text = value.lastMessageContent
    }
}


//MARK: -SetupConstraints
extension ActiveChatCell {
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .red
        gradientView.backgroundColor = .blue
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendNameLabel)
        addSubview(lastMessageLabel)
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView .widthAnchor.constraint(equalToConstant: 8)
        ])
        NSLayoutConstraint.activate([
            friendNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14),
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
    } 
}

//MARK: -SwiftUI
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
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
