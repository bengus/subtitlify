//
//  ProjectsFlowModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

final class ProjectsFlowModuleFactory: ProjectsFlowModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - PaywallFlowModuleFactoryProtocol
    func module(moduleSeed: ProjectsFlowModuleSeed) -> ProjectsFlowModule {
        // Coordinator
        let coordinator = ProjectsFlowCoordinator(
            projectListModuleFactory: container.getProjectListModuleFactory(),
            editorFlowModuleFactory: container.getEditorFlowModuleFactory(),
            projectsProvider: container.projectsProvider
        )
        
        return ProjectsFlowModule(
            moduleInput: coordinator
        )
    }
}
