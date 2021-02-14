//
//  WaitingChatCell.swift
//  testChatMessageKit
//
//  Created by Nikita on 7.02.21.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    
    static var reuseId: String = "WaitingChatCell"

    private let friendImageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let myChat = value as? MyChat else { return }
        friendImageView.sd_setImage(with: URL(string: myChat.friendAvatarStringURL), completed: nil)
        if friendImageView.image != nil {
            friendImageView.backgroundColor = .red
        } else {
            friendImageView.backgroundColor = .green
        }
        
    }
    
}


//MARK: -SetupConstraints
extension WaitingChatCell {
    
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

//MARK: -SwiftUI
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
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
