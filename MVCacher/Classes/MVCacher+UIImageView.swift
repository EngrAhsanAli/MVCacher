//
//  MVCacher+UIImageView.swift
//  MVCacher
//
//  Created by M. Ahsan Ali on 14/09/2019.
//

import UIKit

// MARK: - MVCacher+UIImageView
public extension UIImageView {
    
    /// Set Image with animation
    ///
    /// - Parameters:
    ///   - data: Image data
    ///   - placeholder: placeholder resource
    func mv_setImage(withData data: Data, placeholder: UIImage?) {
        if let placeholder = placeholder {
            setImage(placeholder)
        }
        
        guard let newImage = UIImage(data: data) else {
            return
        }
        
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.setImage(newImage)
        },
                          completion: nil)
        
    }
    
    /// Set Image on main thread
    ///
    /// - Parameter image: image resource
    fileprivate func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
