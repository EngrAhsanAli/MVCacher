//
//  MVCacherDemo+UIRefreshControl.swift
//  MVCacher_Example
//
//  Created by M. Ahsan Ali on 15/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - UIRefreshControl
extension UIRefreshControl {
    
    /// Trigger the refresh control programmatically
    func trigger() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
    
}
