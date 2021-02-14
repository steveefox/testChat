//
//  PeopleViewController.swift
//  testChatMessageKit
//
//  Created by Nikita on 2.02.21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class PeopleViewController: UIViewController {
    
    let currentUser: MyUser
    
    var users: [MyUser] = []
    private var usersListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MyUser>!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCout: Int) -> String {
            switch self {
            case .users:
                return "\(usersCout) people nearby"
            }
        }
    }
    
    
    init(currentUser: MyUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        usersListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(signOut))
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure want to sign out", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = AuthViewController()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        collectionView.delegate = self
    }
    
    private func reloadData(with searchText: String? ) {
        
        let filteredUsers = users.filter { user -> Bool in
            user.contains(filterText: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filteredUsers, toSection: .users)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

//MARK: - createDataSource
extension PeopleViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MyUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind")}
            
            switch section {
            case .users:
                return self.configure(collectionView: collectionView,
                                      cellType:  UserCell.self,
                                      with: user,
                                      for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can't create new section header")}
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknow section kind")}
            
            let users = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configurate(text: section.description(usersCout: users.count),
                                      font: .systemFont(ofSize: 36, weight: .light),
                                      textColor: .label)
            return sectionHeader
        }
    }
    
}

//MARK: -Setup CompositionalLayout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutenvironment ) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section kind")}
            
            switch section {
            case .users:
                return self.createUsersSection()
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        layout.configuration = config
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let spacingSize = CGFloat(15)
        group.interItemSpacing = .fixed(spacingSize)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacingSize
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 16,
                                                        bottom: 10,
                                                        trailing: 16)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

//MARK: UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
    }
}

//MARK: -SearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}


//MARK: -SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
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
