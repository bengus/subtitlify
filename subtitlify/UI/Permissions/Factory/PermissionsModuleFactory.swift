//
//  PermissionsModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation

final class PermissionsModuleFactory: PermissionsModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - EditorModuleFactoryProtocol
    func module(moduleSeed: PermissionsModuleSeed) -> PermissionsModule {
        // ViewModel
        let viewModel = PermissionsViewModel(
            initialState: PermissionsViewState.empty(),
            systemPermissionsProvider: container.systemPermissionsProvider
        )
        
        // ViewController
        let viewController = PermissionsViewController(
            viewModel: viewModel,
            viewFactory: { vm in PermissionsView(viewModel: vm) }
        )
        
        return PermissionsModule(
            viewController: viewController,
            moduleInput: viewModel
        )
    }
}
