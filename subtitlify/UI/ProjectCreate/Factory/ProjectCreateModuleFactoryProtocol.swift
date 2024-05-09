//
//  ProjectCreateModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol ProjectCreateModuleFactoryProtocol {
    func module(moduleSeed: ProjectCreateModuleSeed) -> ProjectCreateModule
}
