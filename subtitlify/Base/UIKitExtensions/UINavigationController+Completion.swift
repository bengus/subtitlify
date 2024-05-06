//
//  UINavigationController+Completion.swift
//
//
//  Created by Boris Bengus on 10/01/2024.
//

import Foundation
import UIKit

public extension UINavigationController {
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completion() }
        }
        self.pushViewController(viewController, animated: animated)
        if animated {
            CATransaction.commit()
        } else {
            completion()
        }
    }
    
    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completion() }
        }
        self.popViewController(animated: animated)
        if animated {
            CATransaction.commit()
        } else {
            completion()
        }
    }
    
    func setViewControllers(
        _ viewControllers: [UIViewController],
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completion() }
        }
        self.setViewControllers(viewControllers, animated: animated)
        if animated {
            CATransaction.commit()
        } else {
            completion()
        }
    }
    
    func popToViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completion() }
        }
        self.popToViewController(viewController, animated: animated)
        if animated {
            CATransaction.commit()
        } else {
            completion()
        }
    }
    
    func popToRootViewController(
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completion() }
        }
        self.popToRootViewController(animated: animated)
        if animated {
            CATransaction.commit()
        } else {
            completion()
        }
    }
}
