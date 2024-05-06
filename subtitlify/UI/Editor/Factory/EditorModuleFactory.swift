//
//  EditorModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation

final class EditorModuleFactory: EditorModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - EditorModuleFactoryProtocol
    func module(moduleSeed: EditorModuleSeed) -> EditorModule {
        // ViewModel
        let viewModel = EditorViewModel(
            initialState: EditorViewState.empty()
        )
        
        // ViewController
        let viewController = EditorViewController(
            viewModel: viewModel,
            viewFactory: { vm in EditorView(viewModel: vm) }
        )
        
        return EditorModule(
            viewController: viewController,
            moduleInput: viewModel
        )
    }
}
