//
//  RootContainerModuleAssemblyProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol RootContainerModuleFactoryProtocol {
    func module(moduleSeed: RootContainerModuleSeed) -> RootContainerModule
}
