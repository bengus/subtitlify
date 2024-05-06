//
//  MediaPermissionsModuleFactory.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation

final class MediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol {
    // MARK: - Dependencies
    private let container: AppContainerProtocol
    
    
    // MARK: - Init
    init(container: AppContainerProtocol) {
        self.container = container
    }
    
    
    // MARK: - EditorModuleFactoryProtocol
    func module(moduleSeed: MediaPermissionsModuleSeed) -> MediaPermissionsModule {
        return MediaPermissionsModule(
            viewController: BaseViewController(),
            moduleInput: FakeMediaPermissionsModuleInput()
        )
    }
}

public final class FakeMediaPermissionsModuleInput: MediaPermissionsModuleInput {
    public init() { }
    public var onAction: ((MediaPermissionsModuleAction) -> Void)?
}
