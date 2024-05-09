//
//  ProjectCreateModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation

final class ProjectCreateModuleFactory: ProjectCreateModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - ProjectCreateModuleFactoryProtocol
    func module(moduleSeed: ProjectCreateModuleSeed) -> ProjectCreateModule {
        // ViewModel
        let viewModel = ProjectCreateViewModel(
            initialState: ProjectCreateViewState.empty(),
            projectsProvider: container.projectsProvider
        )
        
        // ViewController
        let viewController = ProjectCreateViewController(
            viewModel: viewModel,
            viewFactory: { vm in ProjectCreateView(viewModel: vm) }
        )
        
        return ProjectCreateModule(
            viewController: viewController,
            moduleInput: viewModel
        )
    }
}
