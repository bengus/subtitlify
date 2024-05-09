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
    
    private(set) lazy var projectsProvider: ProjectsProviderProtocol = ProjectsProvider(
        defaults: UserDefaults.standard
    )
    
    private(set) lazy var systemPermissionsProvider: SystemPermissionsProviderProtocol = SystemPermissionsProvider()
    
    func getHomeContainerModuleFactory() -> HomeContainerModuleFactoryProtocol {
        return HomeContainerModuleFactory(container: self)
    }
    
    func getEditorFlowModuleFactory() -> EditorFlowModuleFactoryProtocol {
        return EditorFlowModuleFactory(container: self)
    }
    
    func getProjectCreateModuleFactory() -> ProjectCreateModuleFactoryProtocol {
        return ProjectCreateModuleFactory(container: self)
    }
    
    func getEditorModuleFactory() -> EditorModuleFactoryProtocol {
        return EditorModuleFactory(container: self)
    }
    
    func getPermissionsModuleFactory() -> PermissionsModuleFactoryProtocol {
        return PermissionsModuleFactory(container: self)
    }
    
    func getProjectsFlowModuleFactory() -> ProjectsFlowModuleFactoryProtocol {
        return ProjectsFlowModuleFactory(container: self)
    }
    
    func getProjectListModuleFactory() -> ProjectListModuleFactoryProtocol {
        return ProjectListModuleFactory(container: self)
    }
    
    func getAboutFlowModuleFactory() -> AboutFlowModuleFactoryProtocol {
        return AboutFlowModuleFactory(container: self)
    }
    
    func getAboutModuleFactory() -> AboutModuleFactoryProtocol {
        return AboutModuleFactory(container: self)
    }
}
