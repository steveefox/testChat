//
//  UIViewController + Extension.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import UIKit


extension UIViewController {
    
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T
        else { fatalError("Unable to dequeue \(cellType) ") }
        
        cell.configure(with: value)
        return cell
    }
    
}

