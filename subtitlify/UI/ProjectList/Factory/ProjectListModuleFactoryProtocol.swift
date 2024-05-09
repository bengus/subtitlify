//
//  ProjectListModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

public protocol ProjectListModuleFactoryProtocol {
    func module(moduleSeed: ProjectListModuleSeed) -> ProjectListModule
}

public struct ProjectListModuleSeed {}
public protocol ProjectListModuleInput: AnyObject {}
public struct ProjectListModule {}
