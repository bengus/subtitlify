//
//  UIViewController+Helpers.swift
//
//
//  Created by Boris Bengus on 21/01/2024.
//

import Foundation
import UIKit

public extension UIViewController {
    /// Find topmost view controller from specified root view controller
    class func topViewController(fromRootViewController rootViewController: UIViewController) -> UIViewController {
        guard let presentedViewController = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        if
            let presentedNavigationController = presentedViewController as? UINavigationController,
            let lastViewController = presentedNavigationController.viewControllers.last {
            
            return topViewController(fromRootViewController: lastViewController)
        }
        
        return topViewController(fromRootViewController: presentedViewController)
    }
    
    /// Checks if the controller is the root inside UINavigationController
    var isRootInNavigationController: Bool {
        if
            let navigationController = self.navigationController,
            let firstViewController = navigationController.viewControllers.first,
            firstViewController === self
        {
            return true
        } else {
            return false
        }
    }
}
