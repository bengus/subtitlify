//
//  TrackableStackNavigationCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct TransitionBox<T> where T: Hashable {
    public let transitionId: T
    public weak var viewController: UIViewController?
    
    public init(
        transitionId: T,
        viewController: UIViewController
    ) {
        self.transitionId = transitionId
        self.viewController = viewController
    }
}

open class TrackableStackNavigationCoordinator<T>: NavigationCoordinator
    where T: Hashable
{
    private var _transitions = [TransitionBox<T>]()
    
    public var transitions: [TransitionBox<T>] {
        return _transitions.filter { transition -> Bool in
            guard let viewController = transition.viewController else {
                return false
            }
            return navigationController?.viewControllers.contains(viewController) ?? false
        }
    }
    
    public var currentTransition: TransitionBox<T>? {
        transitions.first {
            $0.viewController == navigationController?.viewControllers.last
        }
    }
    
    
    // MARK: - Init
    public override init() {
        
    }
    
    
    // MARK: - Private
    private func flushEmptyTransitions() {
        _transitions = _transitions.compactMap { $0.viewController != nil ? $0 : nil }
    }
    
    
    // MARK: - Navigation logic
    override open func push(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        // Запрещаем пушить в стек без transition id в TrackableStackNavigationCoordinator
        assertionFailure("TrackableStackNavigationCoordinator tries to push viewController without transition id... use push with transition id")
        super.push(
            viewController,
            animated: animated,
            completion: completion
        )
    }
    
    open func push(
        _ viewController: UIViewController,
        transitionId: T,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        _transitions.append(TransitionBox<T>(
            transitionId: transitionId,
            viewController: viewController
        ))
        super.push(
            viewController,
            animated: animated
        ) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    override open func pop(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        super.pop(animated: animated) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    override open func popTo(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        super.popTo(
            viewController,
            animated: animated
        ) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    open func popTo(
        transitionId: T,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard
            let transitionBox = transitions.last(where: { $0.transitionId == transitionId }),
            let viewController = transitionBox.viewController else
        {
            assertionFailure("TrackableStackNavigationCoordinator tries to pop to non-existent transition id...")
            completion?()
            return
        }
        
        popTo(
            viewController,
            animated: animated
        ) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    override open func popToRoot(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        super.popToRoot(animated: animated) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    open func wasPushed(transitionId: T) -> Bool {
        return transitions.contains(where: { $0.transitionId == transitionId })
    }
    
    open func removeFromStack(
        transitionId: T,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        guard
            var viewControllers = navigationController?.viewControllers,
            let transitionBox = transitions.last(where: { $0.transitionId == transitionId }),
            let transitionBoxIndex = transitions.lastIndex(where: { $0.transitionId == transitionId }),
            let viewController = transitionBox.viewController,
            let index = viewControllers.lastIndex(of: viewController) else
        {
            assertionFailure("TrackableStackNavigationCoordinator tries to remove transition with non-existent transition id...")
            completion?()
            return
        }
        
        _transitions.remove(at: transitionBoxIndex)
        viewControllers.remove(at: index)
        navigationController?.setViewControllers(
            viewControllers,
            animated: animated
        ) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
    
    open func replaceInStack(
        replaceTransitionId: T,
        targetTransitionId: T,
        targetViewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        assertConfigured()
        guard
            var viewControllers = navigationController?.viewControllers,
            let transitionBox = transitions.last(where: { $0.transitionId == replaceTransitionId }),
            let transitionBoxIndex = transitions.lastIndex(where: { $0.transitionId == replaceTransitionId }),
            let viewController = transitionBox.viewController,
            let index = viewControllers.lastIndex(of: viewController) else
        {
            assertionFailure("TrackableStackNavigationCoordinator tries to remove transition with non-existent transition id...")
            completion?()
            return
        }
        
        viewControllers.remove(at: index)
        _transitions.remove(at: transitionBoxIndex)
        _transitions.insert(TransitionBox<T>(
            transitionId: targetTransitionId,
            viewController: targetViewController
        ), at: transitionBoxIndex)
        viewControllers.insert(targetViewController, at: index)
        navigationController?.setViewControllers(
            viewControllers,
            animated: animated
        ) { [weak self] in
            self?.flushEmptyTransitions()
            completion?()
        }
    }
}
