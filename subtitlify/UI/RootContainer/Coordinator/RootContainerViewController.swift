//
//  RootContainerViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class RootContainerViewController: BaseViewController {
    // MARK: - Subviews
    private lazy var contentViewWrapper = UIView(frame: .zero)
    
    override public var childForStatusBarStyle: UIViewController? {
        return contentViewController
    }
    
    weak var contentView: UIView? {
        didSet {
            guard oldValue !== contentView else { return }
            
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            
            if let contentView = contentView {
                contentView.frame = contentViewWrapper.bounds
                contentViewWrapper.addSubview(contentView)
            }
        }
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentViewWrapper)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.contentViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    
    // MARK: - Layout
    @discardableResult
    private func layout() -> CGSize {
        contentViewWrapper.pin.all()
        if let contentView = contentView {
            contentView.pin.all()
        }
        
        return view.frame.size
    }
    
    
    // MARK: - Container view controller implementation
    private weak var contentViewController: UIViewController?
    
    func setContentViewController(_ viewController: UIViewController?) {
        if let oldContentViewController = contentViewController {
            oldContentViewController.beginAppearanceTransition(false, animated: false)
            oldContentViewController.willMove(toParent: nil)
            oldContentViewController.view.removeFromSuperview()
            oldContentViewController.removeFromParent()
            oldContentViewController.didMove(toParent: nil)
            oldContentViewController.endAppearanceTransition()

            self.contentViewController = nil
        }
        
        if let viewController = viewController {
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.willMove(toParent: self)
            addChild(viewController)
            contentView = viewController.view
            viewController.didMove(toParent: self)
            viewController.endAppearanceTransition()
        }
        
        self.contentViewController = viewController
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
