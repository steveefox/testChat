//
//  UIView + Extension.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import UIKit


extension UIView {
    
    
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing,
                                        to: .bottomLeading,
                                        startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1),
                                        endColor: #colorLiteral(red: 0.4784313725, green: 0.6901960784, blue: 0.9215686275, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
}
