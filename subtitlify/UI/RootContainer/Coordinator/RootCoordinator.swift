//
//  RootCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class RootCoordinator: RootContainerModuleInput {
    private weak var containerViewController: RootContainerViewController?
    private let launchModuleFactory: () -> UIViewController
    private let homeContainerModuleFactory: HomeContainerModuleFactoryProtocol
    
    /// Current content type embedded in the Root container
    private var currentContentType: RootContentType?
    
    
    // MARK: - Init
    public init(
        containerViewController: RootContainerViewController,
        launchModuleFactory: @escaping () -> UIViewController,
        homeContainerModuleFactory: HomeContainerModuleFactoryProtocol
    ) {
        self.containerViewController = containerViewController
        self.launchModuleFactory = launchModuleFactory
        self.homeContainerModuleFactory = homeContainerModuleFactory
    }
    
    
    // MARK: - Child UI modules
    // Root coordinator is the coordinator with a "static" composition
    // instead of NavigationCoordinator in Flow container modules
    // That's why we hold lazy references to content ui modules
    private lazy var launchViewController = launchModuleFactory()
    private lazy var homeContainerModule = homeContainerModuleFactory.module(
        moduleSeed: HomeContainerModuleSeed()
    )
    // Also in a real app could be more content modules like paywall, onboarding, unauthorized etc.
    // Because of demo we only have launch and home screens inside root.
    
    
    // MARK: - RootContainerModuleInput
    var onAction: ((RootContainerModuleAction) -> Void)?
    
    func start() {
        Task { [weak self] in
            // some async initialization if needed
            
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                setRootContent(.home)
            }
        }
    }
    
    func setRootContent(_ contentType: RootContentType) {
        guard let containerViewController = containerViewController else {
            assertionFailure("RootContainerViewController is nil while setRootContentType")
            return
        }
        
        if
            let currentContentType = currentContentType,
            currentContentType == contentType
        { return }
        
        switch contentType {
        case .launch:
            containerViewController.setContentViewController(launchViewController)
        case .home:
            containerViewController.setContentViewController(homeContainerModule.containerViewController)
        }
        
        currentContentType = contentType
    }
}
