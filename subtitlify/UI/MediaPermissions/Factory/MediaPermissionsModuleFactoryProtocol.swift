//
//  MediaPermissionsModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol MediaPermissionsModuleFactoryProtocol {
    func module(moduleSeed: MediaPermissionsModuleSeed) -> MediaPermissionsModule
}
