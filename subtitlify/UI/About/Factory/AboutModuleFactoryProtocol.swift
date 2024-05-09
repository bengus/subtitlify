//
//  AboutModuleFactoryProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

public protocol AboutModuleFactoryProtocol {
    func module(moduleSeed: AboutModuleSeed) -> AboutModule
}
