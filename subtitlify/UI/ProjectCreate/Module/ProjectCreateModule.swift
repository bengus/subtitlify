//
//  ProjectCreateModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct ProjectCreateModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: ProjectCreateModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: ProjectCreateModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
