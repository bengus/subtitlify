//
//  ProjectsFlowCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class ProjectsFlowCoordinator: NavigationCoordinator,
                                     ProjectsFlowModuleInput
{
    
    private let projectListModuleFactory: ProjectListModuleFactoryProtocol
    private let editorFlowModuleFactory: EditorFlowModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        projectListModuleFactory: ProjectListModuleFactoryProtocol,
        editorFlowModuleFactory: EditorFlowModuleFactoryProtocol
    ) {
        self.projectListModuleFactory = projectListModuleFactory
        self.editorFlowModuleFactory = editorFlowModuleFactory
    }
    
    deinit {
#if DEBUG
        print("Deinit ProjectsFlowCoordinator")
#endif
    }
    
    
    // MARK: - ProjectsFlowModuleInput
    var onAction: ((ProjectsFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        let module = projectListModuleFactory.module(moduleSeed: ProjectListModuleSeed())
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .createProject:
                // In case of creation, open EditorFlow from Home-root modal
                self?.onAction?(.createProject)
            case .openProject(let project):
                self?.openEditorFlow(context: .project(project))
            }
        }
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle (see configure)
        configure(
            navigationController: navigationController,
            rootViewController: module.viewController
        )
        push(module.viewController, animated: false)
    }
    
    func openEditorFlow(context: EditorFlowContext) {
        guard let navigationController = navigationController else {
            assertionFailure("ProjectsFlowCoordinator's navigationController is nil while editor flow opening")
            return
        }
        
        let editorFlowModule = editorFlowModuleFactory.module(
            moduleSeed: EditorFlowModuleSeed(context: context)
        )
        editorFlowModule.moduleInput.onAction = { action in
            switch action {
            case .close:
                // Do nothing because we push it to current navigation controller's stack.
                // .close should be processed only in modal presentation case (see HomeCoordinator)
                break
            }
        }
        // Start flow inside current navigation controller and push it to current stack
        editorFlowModule.moduleInput.start(
            navigationController: navigationController,
            animated: true
        )
    }
}
