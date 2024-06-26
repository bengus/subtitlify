//
//  HomeCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class HomeCoordinator: NSObject,
                             HomeContainerModuleInput,
                             UITabBarControllerDelegate
{
    private weak var containerViewController: HomeContainerViewController?
    private let projectsFlowModuleFactory: ProjectsFlowModuleFactoryProtocol
    private let editorFlowModuleFactory: EditorFlowModuleFactoryProtocol
    private let aboutFlowModuleFactory: AboutFlowModuleFactoryProtocol
    
    
    // MARK: - Init
    init(
        containerViewController: HomeContainerViewController,
        projectsFlowModuleFactory: ProjectsFlowModuleFactoryProtocol,
        editorFlowModuleFactory: EditorFlowModuleFactoryProtocol,
        aboutFlowModuleFactory: AboutFlowModuleFactoryProtocol
    ) {
        self.containerViewController = containerViewController
        self.projectsFlowModuleFactory = projectsFlowModuleFactory
        self.editorFlowModuleFactory = editorFlowModuleFactory
        self.aboutFlowModuleFactory = aboutFlowModuleFactory
        
        super.init()
        
        containerViewController.delegate = self
        containerViewController.onViewDidFirstAppear = { [weak self] in
            guard let self else { return }
            
            // First time we should prepare our Parent flows:
            // - projectsFlowModule
            // - aboutModule
            // Then it will be ready to be embedded into TabBarController
            projectsFlowModule.moduleInput.start(navigationController: projectsFlowNavigationController)
            aboutFlowModule.moduleInput.start(navigationController: aboutFlowNavigationController)
            
            self.containerViewController?.setViewControllers(
                [
                    projectsFlowNavigationController,
                    emptyEditorViewController,
                    aboutFlowNavigationController
                ],
                animated: false
            )
        }
    }
    
    
    // MARK: - Child UI modules
    // ProjectsFlowCoordinator and AboutFlowCoordinator is a NavigationCoordinators
    // We have to create new UINavigationController for such coordinators and start on it
    // Or reuse an existing one. In this case we host it in new UINavigationController
    private lazy var projectsFlowNavigationController = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Projects"
        navigationController.tabBarItem.image = UIImage(named: "24_home")
        return navigationController
    }()
    private lazy var projectsFlowModule = {
        let module = projectsFlowModuleFactory.module(moduleSeed: ProjectsFlowModuleSeed())
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .createProject:
                self?.openEditorFlow(context: .new)
            }
        }
        return module
    }()
    
    private lazy var aboutFlowNavigationController = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "About"
        navigationController.tabBarItem.image = UIImage(named: "24_question_mark_circle")
        return navigationController
    }()
    private lazy var aboutFlowModule = {
        let module = aboutFlowModuleFactory.module(moduleSeed: AboutFlowModuleSeed())
//        module.moduleInput.onAction = { [weak self] action in
//            switch action {
//                // No actions here
//            }
//        }
        return module
    }()
    
    // This is a fake editor for tabbar, actual EditorFlow will be presented as modal
    private lazy var emptyEditorViewController = {
        let viewController = UIViewController()
        if !Design.isIpad {
            // Probably hack with an imageInsets is not the best solution to center "Add" button.
            // It could be Better to Create custom UITabBar but for Demo is ok
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        }
        viewController.tabBarItem.image = UIImage(named: "42_plus_circle1")?.withRenderingMode(.alwaysOriginal)
        return viewController
    }()
    
    
    // MARK: - HomeContainerModuleInput
    var onAction: ((HomeContainerModuleAction) -> Void)?
    
    private var currentContentType: HomeContentType? {
        guard let containerViewController = containerViewController else { return nil }
        switch containerViewController.selectedIndex {
        case 0:
            return .projects
        case 2:
            return .about
        default:
            return nil
        }
    }
    
    func setHomeContent(_ contentType: HomeContentType) {
        guard let containerViewController = containerViewController else {
            assertionFailure("HomeContainerViewController is nil while setHomeContentType")
            return
        }
        
        if
            let currentContentType = currentContentType,
            currentContentType == contentType
        { return }
        
        switch contentType {
        case .projects:
            containerViewController.selectedIndex = 0
        case .about:
            containerViewController.selectedIndex = 2
        }
    }
    
    private func openEditorFlow(context: EditorFlowContext) {
        guard
            let window = UIApplication.shared.findKeyWindow(),
            let rootViewController = window.rootViewController else
        {
            assertionFailure("Can't find keyWindow or rootViewController while editor opening")
            return
        }
        
        let navigationController = UINavigationController()
        let editorFlowModule = editorFlowModuleFactory.module(moduleSeed: EditorFlowModuleSeed(context: context))
        editorFlowModule.moduleInput.onAction = { [weak navigationController] action in
            switch action {
            case .close:
                navigationController?.dismiss(animated: true)
            }
        }
        if Design.isIpad {
            navigationController.modalPresentationStyle = .automatic
        } else {
            navigationController.modalPresentationStyle = .fullScreen
        }
        navigationController.isModalInPresentation = true
        let topViewController = UIViewController.findTopViewController(fromRootViewController: rootViewController)
        
        // Start flow inside NavigationController and present it
        editorFlowModule.moduleInput.start(
            navigationController: navigationController,
            animated: false // to prevent double animation start non-animated, but animate presenting
        )
        topViewController.present(navigationController, animated: true)
    }
    
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === emptyEditorViewController {
            openEditorFlow(context: .new)
            return false
        } else {
            return true
        }
    }
}
