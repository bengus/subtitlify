//
//  AboutFlowCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class AboutFlowCoordinator: NavigationCoordinator,
                                  AboutFlowModuleInput
{
    
    private let aboutModuleFactory: AboutModuleFactoryProtocol
    private let editorFlowModuleFactory: EditorFlowModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        aboutModuleFactory: AboutModuleFactoryProtocol,
        editorFlowModuleFactory: EditorFlowModuleFactoryProtocol
    ) {
        self.aboutModuleFactory = aboutModuleFactory
        self.editorFlowModuleFactory = editorFlowModuleFactory
    }
    
    deinit {
#if DEBUG
        print("Deinit AboutFlowCoordinator")
#endif
    }
    
    
    // MARK: - AboutFlowModuleInput
    var onAction: ((AboutFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        let module = aboutModuleFactory.module(moduleSeed: AboutModuleSeed())
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .openDemo(let isBuffered):
                self?.openEditorFlow(context: .demo(isBuffered: isBuffered))
            }
        }
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle (see configure)
        module.viewController.addDisposable(self)
        configure(navigationController: navigationController)
        push(module.viewController, animated: false)
    }
    
    func openEditorFlow(context: EditorFlowContext) {
        guard let navigationController = navigationController else {
            assertionFailure("AboutFlowCoordinator's navigationController is nil while editor flow opening")
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
