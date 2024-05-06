//
//  HomeContainerModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public enum HomeContainerModuleAction {
    // Actions that will be available outside the module should be declared here
}

public protocol HomeContainerModuleInput: AnyObject {
    var onAction: ((HomeContainerModuleAction) -> Void)? { get set }
    func setHomeContent(_ contentType: HomeContentType)
}
