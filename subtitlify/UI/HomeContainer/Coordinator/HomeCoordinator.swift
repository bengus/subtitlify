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
    private let projectsModuleFactory: () -> UIViewController
    private let editorFlowModuleFactory: () -> UIViewController
    private let aboutModuleFactory: () -> UIViewController
    
    
    // MARK: - Init
    init(
        containerViewController: HomeContainerViewController,
        projectsModuleFactory: @escaping () -> UIViewController,
        editorFlowModuleFactory: @escaping () -> UIViewController,
        aboutModuleFactory: @escaping () -> UIViewController
    ) {
        self.containerViewController = containerViewController
        self.projectsModuleFactory = projectsModuleFactory
        self.editorFlowModuleFactory = editorFlowModuleFactory
        self.aboutModuleFactory = aboutModuleFactory
        
        super.init()
        
        containerViewController.delegate = self
        containerViewController.onViewDidFirstAppear = { [weak self] in
            guard let self else { return }
            self.containerViewController?.setViewControllers(
                [
                    projectsViewController,
                    emptyEditorViewController,
                    aboutViewController
                ],
                animated: false
            )
        }
    }
    
    
    // MARK: - Child UI modules
    private lazy var projectsViewController = {
        let viewController = projectsModuleFactory()
        viewController.tabBarItem.title = "Projects"
        viewController.tabBarItem.image = UIImage(named: "24_home")
        return viewController
    }()
    
    // This is a fake editor for tabbar, actual EditorFlow will be presented as modal
    private lazy var emptyEditorViewController = {
        let viewController = UIViewController()
        // Probably not the best solution to center "Add" button
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        viewController.tabBarItem.image = UIImage(named: "48_plus_circle1")?.withRenderingMode(.alwaysOriginal)
        return viewController
    }()
    
    private lazy var aboutViewController = {
        let viewController = aboutModuleFactory()
        viewController.tabBarItem.title = "About"
        viewController.tabBarItem.image = UIImage(named: "24_question_mark_circle")
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
    
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === emptyEditorViewController {
            // open editor flow
            return false
        } else {
            return true
        }
    }
}
