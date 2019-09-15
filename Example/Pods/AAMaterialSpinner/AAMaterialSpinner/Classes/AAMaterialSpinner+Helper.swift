//
//  AAMaterialSpinner+Helper.swift
//  AAMaterialSpinner
//
//  Created by MacBook Pro on 08/03/2019.
//

import UIKit

var AssociatedSpinnerHandle: UInt8 = 0
var AssociatedVCHandle: UInt8 = 0

public extension UIView {
    
    func addMaterialSpinner(size: CGFloat = 70) -> AAMaterialSpinner {
        let spinnerView = AAMaterialSpinner()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(spinnerView)
        
        let widthConstraint = NSLayoutConstraint(item: spinnerView, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size)
        
        let heightConstraint = NSLayoutConstraint(item: spinnerView, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size)
        
        spinnerView.addConstraints([widthConstraint, heightConstraint])
        
        let xConstraint = NSLayoutConstraint(item: spinnerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: spinnerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([xConstraint, yConstraint])
        return spinnerView
    }
    
}
