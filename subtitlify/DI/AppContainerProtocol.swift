//
//  AppContainerProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

protocol AppContainerProtocol {
    var rootContainerModule: RootContainerModule { get }
    
    // Services
    var projectsProvider: ProjectsProviderProtocol { get }
    var systemPermissionsProvider: SystemPermissionsProviderProtocol { get }
    
    // UI Modules factories
    func getHomeContainerModuleFactory() -> HomeContainerModuleFactoryProtocol
    
    // Editor flow
    func getEditorFlowModuleFactory() -> EditorFlowModuleFactoryProtocol
    func getProjectCreateModuleFactory() -> ProjectCreateModuleFactoryProtocol
    func getEditorModuleFactory() -> EditorModuleFactoryProtocol
    func getPermissionsModuleFactory() -> PermissionsModuleFactoryProtocol
    
    // Projects flow
    func getProjectsFlowModuleFactory() -> ProjectsFlowModuleFactoryProtocol
    func getProjectListModuleFactory() -> ProjectListModuleFactoryProtocol
    
    // About flow
    func getAboutFlowModuleFactory() -> AboutFlowModuleFactoryProtocol
    func getAboutModuleFactory() -> AboutModuleFactoryProtocol
}
