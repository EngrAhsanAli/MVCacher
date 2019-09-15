//
//  ImageCell.swift
//  MVCacher_Example
//
//  Created by M. Ahsan Ali on 14/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MVCacher

/// MARK:- ImageCell
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

// MARK: - Helper methods
extension ImageCell {
    
    /// Cell selection color
    var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
            self.bringSubviewToFront(view)
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? .clear
        }
    }
}
