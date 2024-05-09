//
//  ProjectListModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

final class ProjectListModuleFactory: ProjectListModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - ProjectListModuleFactoryProtocol
    func module(moduleSeed: ProjectListModuleSeed) -> ProjectListModule {
        fatalError()
    }
}
