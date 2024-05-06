//
//  AppContainerProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

protocol AppContainerProtocol {
    var rootContainerModule: RootContainerModule { get }
    
    func getHomeContainerModuleFactory() -> HomeContainerModuleFactoryProtocol
}
