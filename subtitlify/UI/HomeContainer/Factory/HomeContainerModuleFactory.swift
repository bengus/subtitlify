//
//  HomeContainerModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

final class HomeContainerModuleFactory: HomeContainerModuleFactoryProtocol {
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - HomeCoordinatorModuleFactoryProtocol
    func module(moduleSeed: HomeContainerModuleSeed) -> HomeContainerModule {
        // Container ViewController
        let containerViewController = HomeContainerViewController()
        
        // Coordinator
        let coordinator = HomeCoordinator(
            containerViewController: containerViewController,
            projectsModuleFactory: {
                let vc = BaseViewController()
                vc.onViewDidLoad = { [weak vc] in
                    vc?.view.backgroundColor = .orange
                }
                return vc
            },
            editorFlowModuleFactory: container.getEditorFlowModuleFactory(),
            aboutModuleFactory: { let vc = BaseViewController()
                vc.onViewDidLoad = { [weak vc] in
                    vc?.view.backgroundColor = .yellow
                }
                return vc }
        )
        /// Hold a reference to the coordinator to follow the lifecycle of the ViewController.
        /// DisposeBag helps to avoid direct knowledge about a coordinator from a ViewController.
        containerViewController.addDisposable(coordinator)
        
        return HomeContainerModule(
            containerViewController: containerViewController,
            moduleInput: coordinator
        )
    }
}
