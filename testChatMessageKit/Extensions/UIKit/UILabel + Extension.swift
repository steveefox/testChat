//
//  UILabel + Extension.swift
//  testChatMessageKit
//
//  Created by Nikita on 31.01.21.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir(size: 20)) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
