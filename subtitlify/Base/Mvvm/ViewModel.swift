//
//  ViewModel.swift
//
//
//  Created by Boris Bengus on 10/01/2024.
//

import Foundation
import Combine
import UIKit

open class ViewModel<VS, ViewAction, Eff>
where VS: Equatable,
      ViewAction: Any,
      Eff: Any
{
    @Published
    public private(set) var state: VS
    
    @Published
    public private(set) var viewActions: ViewAction?
    
    @Published
    public private(set) var effects: Eff?
    
    public var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Init
    public init(initialState: VS) {
        self.state = initialState
        // Subscribe to viewActions
        $viewActions.sink { [weak self] action in
            if let action = action {
                self?.onViewAction(action)
            }
        }.store(in: &cancellables)
    }
    
    
    // MARK: - Life cycle
    open func onViewWillAppear() {
        // Do nothing
    }
    
    open func onViewDidAppear() {
        // Do nothing
    }
    
    open func onViewDidFirstAppear() {
        // Do nothing
    }
    
    open func onViewWillDisappear() {
        // Do nothing
    }
    
    open func onViewDidDisappear() {
        // Do nothing
    }
    
    
    // MARK: - State, view actions and effects
    /// Should be called from View when you need to perform an action on ViewModel side.
    /// Usually View Actions is declared inside ViewModel subclass.
    /// - Parameter action: View action for example: .someButtonTapped
    open func sendViewAction(_ action: ViewAction) {
        self.viewActions = action
    }
    
    /// Should be called inside subclass of ViewModel when you need to publish new state
    /// - Parameter newState: New view state
    open func publishState(_ newState: VS) {
        self.state = newState
    }
    
    /// Should be called inside subclass of ViewModel when you need to publish new Effect for view
    /// - Parameter newEffect: New effect which will be processed by a view and performed on view side
    open func publishEffect(_ newEffect: Eff) {
        self.effects = newEffect
    }
    
    
    // MARK: - Actions handler
    open func onViewAction(_ action: ViewAction) {
        // Do nothing
    }
}
