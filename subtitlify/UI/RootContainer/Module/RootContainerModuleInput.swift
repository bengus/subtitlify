//
//  RootContainerModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public enum RootContainerModuleAction {
    // Actions that will be available outside the module should be declared here
}

public protocol RootContainerModuleInput: AnyObject {
    var onAction: ((RootContainerModuleAction) -> Void)? { get set }
    func start()
    func setRootContent(_ contentType: RootContentType)
}
