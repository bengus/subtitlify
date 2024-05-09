//
//  AboutModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

final class AboutModuleFactory: AboutModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - AboutModuleFactoryProtocol
    func module(moduleSeed: AboutModuleSeed) -> AboutModule {
        // ViewModel
        let viewModel = AboutViewModel(initialState: AboutViewState.empty())
        
        // ViewController
        let viewController = AboutViewController(
            viewModel: viewModel,
            viewFactory: { vm in AboutView(viewModel: vm) }
        )
        
        return AboutModule(
            viewController: viewController,
            moduleInput: viewModel
        )
    }
}
