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
    
    public private(set) weak var rootViewController: UIViewController?
    
    open var isConfigured: Bool {
        return navigationController != nil
            && rootViewController != nil
    }
    
    
    // MARK: - Init
    public init() {
        
    }
    
    
    // MARK: - Internal
    func assertConfigured() {
        if !isConfigured {
            assertionFailure("\(type(of: self)) tries to work in non-configured state, use - configure(navigationController:rootViewController:)")
        }
    }
    
    
    // MARK: - Navigation methods
    open func configure(
        navigationController: UINavigationController,
        rootViewController: UIViewController & DisposeBag
    ) {
        self.navigationController = navigationController
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle
        rootViewController.addDisposable(self)
        self.rootViewController = rootViewController
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
}
