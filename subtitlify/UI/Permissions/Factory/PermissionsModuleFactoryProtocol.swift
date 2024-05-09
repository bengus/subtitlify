//
//  PermissionsModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol PermissionsModuleFactoryProtocol {
    func module(moduleSeed: PermissionsModuleSeed) -> PermissionsModule
}
