//
//  EditorFlowCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class EditorFlowCoordinator: NavigationCoordinator,
                                   EditorFlowModuleInput
{
    private let editorModuleFactory: EditorModuleFactoryProtocol
    private let mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        editorModuleFactory: EditorModuleFactoryProtocol,
        mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    ) {
        self.editorModuleFactory = editorModuleFactory
        self.mediaPermissionsModuleFactory = mediaPermissionsModuleFactory
    }
    
    
    // MARK: - Child UI modules
    private lazy var editorModule: EditorModule = {
        let module = editorModuleFactory.module(moduleSeed: EditorModuleSeed())
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .close:
                self?.onAction?(.close)
            }
        }
        return module
    }()
    
    
    // MARK: - EditorFlowModuleInput
    var onAction: ((EditorFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        let viewController = editorModule.viewController
        configure(
            navigationController: navigationController,
            rootViewController: viewController
        )
        push(viewController, animated: false)
    }
    
    
    // MARK: - Coordinator
//    private lazy var paywallModule: PaywallModule = {
//        let module = paywallModuleFactory.module(moduleSeed: PaywallModuleSeed())
//        module.moduleInput.onAction = { [weak self] action in
//            switch action {
//            case .openProductList:
//                self?.openProductList()
//            case .close:
//                self?.onAction?(.close)
//            }
//        }
//        return module
//    }()
    
//    private func openProductList() {
//        let productListModule = productListModuleFactory.module(moduleSeed: ProductListModuleSeed())
//        productListModule.moduleInput.onAction = { [weak self] action in
//            switch action {
//            case .purchased:
//                self?.onAction?(.close)
//            }
//        }
//        let viewController = productListModule.viewController
//        push(viewController, animated: true)
//    }
}
