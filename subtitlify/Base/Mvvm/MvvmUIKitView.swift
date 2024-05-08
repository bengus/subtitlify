//
//  MvvmUIKitView.swift
//
//
//  Created by Boris Bengus on 10/01/2024.
//

import Foundation
import Combine
import UIKit

open class MvvmUIKitView<VM, VS, VA, Eff>: UIView,
                                           DisposeBag,
                                           DisposeBagHolder
where VM: ViewModel<VS, VA, Eff>,
      VA: Any,
      Eff: Any
{
    public let viewModel: VM
    public var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Init
    public init(viewModel: VM) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
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
    
    @available(*, unavailable, message: "Use another init()")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - State and effects
    open func onState(_ state: VS) {
        // Do nothing
    }
    
    open func onEffect(_ eff: Eff) {
        // Do nothing
    }
    
    
    // MARK: - DisposeBag
    public let disposeBag: DisposeBag = DisposeBagImpl()
}
