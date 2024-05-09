//
//  NavigationCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

open class NavigationCoordinator {
    public private(set) weak var navigationController: UINavigationController?
    
    
    // MARK: - Init
    public init() {
        
    }
    
    
    // MARK: - Internal
    func assertConfigured() {
        if navigationController == nil {
            assertionFailure("\(type(of: self)) tries to work in non-configured state, use - configure(navigationController:)")
        }
    }
    
    
    // MARK: - Navigation methods
    open func configure(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    open func push(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        navigationController?.pushViewController(
            viewController,
            animated: animated
        ) {
            completion?()
        }
    }
    
    open func pop(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        navigationController?.popViewController(animated: animated) {
            completion?()
        }
    }
    
    open func popTo(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        navigationController?.popToViewController(
            viewController,
            animated: animated
        ) {
            completion?()
        }
    }
    
    open func popToRoot(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        navigationController?.popToRootViewController(animated: animated) {
            completion?()
        }
    }
    
    open func replace(
        with viewControllers: [UIViewController],
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        navigationController?.setViewControllers(
            viewControllers,
            animated: animated
        ) {
            completion?()
        }
    }
}
