//
//  RootContainerModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

final class RootContainerModuleFactory: RootContainerModuleFactoryProtocol {
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - RootCoordinatorModuleFactoryProtocol
    func module(moduleSeed: RootContainerModuleSeed) -> RootContainerModule {
        // Container ViewController
        let containerViewController = RootContainerViewController()
        
        // Coordinator
        let coordinator = RootCoordinator(
            containerViewController: containerViewController,
            launchModuleFactory: { LaunchViewController() },
            homeContainerModuleFactory: container.getHomeContainerModuleFactory()
        )
        /// Hold a reference to the coordinator to follow the lifecycle of the ViewController.
        /// DisposeBag helps to avoid direct knowledge about a coordinator from a ViewController.
        containerViewController.addDisposable(coordinator)
        
        return RootContainerModule(
            containerViewController: containerViewController,
            moduleInput: coordinator
        )
    }
}
