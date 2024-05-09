//
//  AboutFlowModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

public protocol AboutFlowModuleFactoryProtocol {
    func module(moduleSeed: AboutFlowModuleSeed) -> AboutFlowModule
}
