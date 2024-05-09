//
//  ProjectListModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct ProjectListModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: ProjectListModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: ProjectListModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
