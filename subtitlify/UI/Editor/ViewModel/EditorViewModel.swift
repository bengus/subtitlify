//
//  EditorViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

extension EditorViewModel {
    enum ViewAction {
        case closeTap
    }
}

extension EditorViewModel {
    enum Eff {
        case registerForRemoteNotifications
    }
}

class EditorViewModel:
    ViewModel
<
    EditorViewState,
    EditorViewModel.ViewAction,
    EditorViewModel.Eff
>,
    EditorModuleInput
{
    // MARK: - Init
    override init(initialState: EditorViewState) {
        super.init(initialState: initialState)
    }
    
    
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        reload()
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .closeTap:
            close()
        }
    }
    
    private func close() {
        onAction?(.close)
    }
    
    private func reload() {
        publishState(
            EditorViewState(isLoading: false)
        )
    }
    
    
    // MARK: - EditorModuleInput
    var onAction: ((EditorModuleAction) -> Void)?
}
