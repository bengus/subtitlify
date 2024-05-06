//
//  EditorModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol EditorModuleFactoryProtocol {
    func module(moduleSeed: EditorModuleSeed) -> EditorModule
}
