//
//  AAMaterialSpinner+UIResponder.swift
//  AAMaterialSpinner
//
//  Created by MacBook Pro on 15/03/2019.
//

import UIKit

public extension UIResponder {
    
    private var rootViewController: UIViewController {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("AAMaterialSpinner - Application key window not found. Please check UIWindow in AppDelegate.")
        }
        
        return root
    }
    
    var aa_ms: AAMaterialSpinner {
        get {
            if let spinner = objc_getAssociatedObject(self, &AssociatedSpinnerHandle) as? AAMaterialSpinner {
                return spinner
            }
            return AAMaterialSpinner()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedSpinnerHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var aa_ms_vc: UIViewController? {
        get {
            if let spinner = objc_getAssociatedObject(self, &AssociatedVCHandle) as? UIViewController {
                return spinner
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedVCHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func aa_vc_material_spinner( bgColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),
                                        size: CGFloat = 50) -> UIViewController {
        
        let vc = UIViewController()
        vc.view.backgroundColor = bgColor
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.aa_ms = vc.view.addMaterialSpinner(size: size)
        aa_ms_vc = vc
        return vc
    }
    
    func aa_present_material_spinner(_ vc: UIViewController? = nil) {
        
        guard let materialSpinner = aa_ms_vc else { return }
        let presenter = (vc ?? rootViewController)
        presenter.present(materialSpinner, animated: true, completion: {
            materialSpinner.aa_ms.beginRefreshing()
        })
    }
    
    func aa_dismiss_material_spinner(_ completion: (() -> ())? = nil) {
        aa_ms_vc?.aa_ms.endRefreshing()
        aa_ms_vc?.dismiss(animated: true, completion: completion)
    }

}



