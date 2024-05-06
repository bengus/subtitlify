//
//  MediaPermissionsModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct MediaPermissionsModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: MediaPermissionsModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: MediaPermissionsModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
