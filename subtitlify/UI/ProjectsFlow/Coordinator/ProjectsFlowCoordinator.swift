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
    private let projectsProvider: ProjectsProviderProtocol
    
    
    // MARK: - Init
    public init(
        projectListModuleFactory: ProjectListModuleFactoryProtocol,
        editorFlowModuleFactory: EditorFlowModuleFactoryProtocol,
        projectsProvider: ProjectsProviderProtocol
    ) {
        self.projectListModuleFactory = projectListModuleFactory
        self.editorFlowModuleFactory = editorFlowModuleFactory
        self.projectsProvider = projectsProvider
    }
    
    deinit {
#if DEBUG
        print("Deinit ProjectsFlowCoordinator")
#endif
    }
    
    
    // MARK: - Child UI modules
    private weak var projectListModuleInput: ProjectListModuleInput?
    
    
    // MARK: - ProjectsFlowModuleInput
    var onAction: ((ProjectsFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        
//        let module = projectListModuleFactory.module(moduleSeed: ProjectListModuleSeed())
//        module.moduleInput.onAction = { [weak self] action in
//            switch action {
//            case .projectSelected(let project):
//                self?.openEditorFlow(project)
//            }
//        }
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle (see configure)
        let viewController = BaseViewController()
        viewController.navigationItem.title = "Project list"
        viewController.view.backgroundColor = .red
//        viewController.hidesBottomBarWhenPushed = true
        viewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ddd)))
        
        configure(
            navigationController: navigationController,
            rootViewController: viewController
        )
        push(viewController, animated: false)
    }
    
    @objc
    private func ddd() {
        if let firstProject = projectsProvider.getAllProjects().first {
            openEditorFlow(project: firstProject)
        }
    }
    
    func openEditorFlow(project: Project) {
        guard let navigationController = navigationController else {
            assertionFailure("ProjectsFlowCoordinator's navigationController is nil while editor flow opening")
            return
        }
        
        let editorFlowModule = editorFlowModuleFactory.module(
            moduleSeed: EditorFlowModuleSeed(context: .project(project))
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
