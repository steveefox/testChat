//
//  UIImageView + Extension.swift
//  testChatMessageKit
//
//  Created by Nikita on 31.01.21.
//

import UIKit

extension UIImageView {
     
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
}
