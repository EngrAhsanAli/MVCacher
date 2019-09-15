//
//  AAMaterialSpinner+Masked.swift
//  AAMaterialSpinner
//
//  Created by Ahsan ALI on 24/05/2019.
//

import UIKit

var AssociatedMaskedView: UInt8 = 1

public struct AAMaskedSpinner {
    var maskView: UIView
    var spinnerView: AAMaterialSpinner
}

public extension AAMaterialSpinner {
    
    static var aa_masked_ms: AAMaskedSpinner? {
        get {
            return objc_getAssociatedObject(self, &AssociatedMaskedView) as? AAMaskedSpinner
        }
        set {
            objc_setAssociatedObject(self, &AssociatedMaskedView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    class func setMaskedSpinnerView(bgColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),
                                    spinnerSize: CGFloat = 50,
                                    spinnerWidth: CGFloat = 2,
                                    spinnerColor: UIColor = .black,
                                    maskFrame: CGRect? = nil) -> AAMaterialSpinner  {
        
        let mask: UIView = {
            let view = UIView()
            view.backgroundColor = bgColor
            let frame = UIApplication.shared.keyWindow?.frame ?? UIScreen.main.applicationFrame
            view.frame = maskFrame ?? frame
            return view
        }()
        let spinnerView = mask.addMaterialSpinner(size: spinnerSize)
        spinnerView.circleLayer.lineWidth = spinnerWidth
        spinnerView.circleLayer.strokeColor = spinnerColor.cgColor
        aa_masked_ms = AAMaskedSpinner(maskView: mask, spinnerView: spinnerView)
        return spinnerView
    }
    
    class func showMaskedSpinner( _ onViewController: UIViewController? = nil) {
        
        guard let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController, let maskedView = aa_masked_ms else {
            fatalError("AAMaterialSpinner - Application key window not found. Please check UIWindow in AppDelegate.")
        }
        
        let vc = onViewController ?? rootViewController
        vc.view.addSubview(maskedView.maskView)
        maskedView.spinnerView.beginRefreshing()
        
    }
    
    class func dismissMaskedSpinner() {
        aa_masked_ms?.spinnerView.endRefreshing()
        aa_masked_ms?.maskView.removeFromSuperview()
    }
    
    
}
