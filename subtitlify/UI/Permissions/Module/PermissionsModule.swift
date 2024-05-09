//
//  PermissionsModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct PermissionsModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: PermissionsModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: PermissionsModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
