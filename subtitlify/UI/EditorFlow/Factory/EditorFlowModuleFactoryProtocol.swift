//
//  EditorFlowModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol EditorFlowModuleFactoryProtocol {
    func module(moduleSeed: EditorFlowModuleSeed) -> EditorFlowModule
}
