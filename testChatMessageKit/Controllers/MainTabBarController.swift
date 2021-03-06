//
//  MainTabBarController.swift
//  testChatMessageKit
//
//  Created by Nikita on 2.02.21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: MyUser
    
    //Default MyUser only for SwiftUI(Canvas mode)
    init(currentUser: MyUser = MyUser(username: "",
                                      email: "",
                                      description: "",
                                      sex: "",
                                      avatarStringURL: "",
                                      id: "")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        
        let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration)
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfiguration )
        
        viewControllers = [
            generateNavigationController(rootViewController: peopleViewController,
                                         title: "People",
                                         image: peopleImage),
            generateNavigationController(rootViewController: listViewController,
                                                        title: "Conversation",
                                                        image: convImage)
        ]
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
}
