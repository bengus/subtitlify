//
//  AppContainer.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

final class AppContainer: AppContainerProtocol {
    // MARK: - Init
    init() {
        // Here usually could be an environment detection
        // reading bundle env values
        // checking local build config
    }
    
    
    // MARK: - AppContainerProtocol
    private(set) lazy var rootContainerModule: RootContainerModule = {
        let assembly = RootContainerModuleFactory(container: self)
        return assembly.module(moduleSeed: RootContainerModuleSeed())
    }()
    
    func getHomeContainerModuleFactory() -> HomeContainerModuleFactoryProtocol {
        return HomeContainerModuleFactory(container: self)
    }
}
