//
//  AboutFlowModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

final class AboutFlowModuleFactory: AboutFlowModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - PaywallFlowModuleFactoryProtocol
    func module(moduleSeed: AboutFlowModuleSeed) -> AboutFlowModule {
        // Coordinator
        let coordinator = AboutFlowCoordinator(
            aboutModuleFactory: container.getAboutModuleFactory(),
            editorFlowModuleFactory: container.getEditorFlowModuleFactory()
        )
        
        return AboutFlowModule(
            moduleInput: coordinator
        )
    }
}
