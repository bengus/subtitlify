//
//  BaseTabBarController.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

open class BaseTabBarController: UITabBarController,
                                 ViewLifecycleObservable,
                                 DisposeBag,
                                 DisposeBagHolder
{
    open var isAppearedAtLeast = false
    open var isAppeared = false
    
    
    // MARK: - Overrides
    override open func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear?()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isAppearedAtLeast {
            isAppearedAtLeast = true
            onViewDidFirstAppear?()
        }
        isAppeared = true
        
        onViewDidAppear?()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onViewWillDisappear?()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isAppeared = false
        onViewDidDisappear?()
    }
    
    override open func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            onViewWillMoveToNilParent?()
        }
    }
    
    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            onViewDidMoveToNilParent?()
        }
    }
    
    
    // MARK: - ViewLifecycleObservable
    public var onViewDidLoad: (() -> ())?
    public var onViewWillAppear: (() -> ())?
    public var onViewDidAppear: (() -> ())?
    public var onViewWillDisappear: (() -> ())?
    public var onViewDidDisappear: (() -> ())?
    public var onViewDidFirstAppear: (() -> ())?
    public var onViewWillMoveToNilParent: (() -> ())?
    public var onViewDidMoveToNilParent: (() -> ())?
    
    
    // MARK: - DisposeBag
    public let disposeBag: DisposeBag = DisposeBagImpl()
}

