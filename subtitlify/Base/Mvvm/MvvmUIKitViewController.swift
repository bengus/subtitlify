//
//  MvvmUIKitViewController.swift
//
//
//  Created by Boris Bengus on 10/01/2024.
//

import Foundation
import Combine
import UIKit

open class MvvmUIKitViewController<View, VM, VS, VA, Eff>: BaseViewController
where View: MvvmUIKitView<VM, VS, VA, Eff>,
      VM: ViewModel<VS, VA, Eff>,
      VA: Any,
      Eff: Any
{
    public lazy var mvvmView: View = viewFactory(viewModel)
    public let viewFactory: (VM) -> View
    public let viewModel: VM
    public var cancellables: Set<AnyCancellable> = []

    
    // MARK: - Init
    public init(
        viewModel: VM,
        viewFactory: @escaping (VM) -> View
    ) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use another init()")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cycle
    open override func loadView() {
        self.view = mvvmView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to state
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] state in
                self?.onState(state)
            }.store(in: &cancellables)
        
        // Subscribe to effects
        viewModel.$effects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] eff in
                if let eff = eff {
                    self?.onEffect(eff)
                }
            }.store(in: &cancellables)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if !isAppearedAtLeast {
            viewModel.onViewDidFirstAppear()
        }
        
        super.viewDidAppear(animated)
        
        viewModel.onViewDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.onViewDidDisappear()
    }
    
    
    // MARK: - State and effects
    open func onState(_ state: VS) {
        // Do nothing
    }
    
    open func onEffect(_ eff: Eff) {
        // Do nothing
    }
}
