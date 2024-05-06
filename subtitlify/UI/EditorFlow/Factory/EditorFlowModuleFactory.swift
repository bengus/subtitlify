//
//  EditorFlowModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

final class EditorFlowModuleFactory: EditorFlowModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - PaywallFlowModuleFactoryProtocol
    func module(moduleSeed: EditorFlowModuleSeed) -> EditorFlowModule {
        // Coordinator
        let coordinator = EditorFlowCoordinator(
            editorModuleFactory: container.getEditorModuleFactory(),
            mediaPermissionsModuleFactory: container.getMediaPermissionsModuleFactory()
        )
        
        return EditorFlowModule(
            moduleInput: coordinator
        )
    }
}
