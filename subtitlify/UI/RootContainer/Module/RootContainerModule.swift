//
//  RootContainerModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct RootContainerModule {
    public let containerViewController: UIViewController & DisposeBag
    public let moduleInput: RootContainerModuleInput
    
    public init(
        containerViewController: UIViewController & DisposeBag,
        moduleInput: RootContainerModuleInput
    ) {
        self.containerViewController = containerViewController
        self.moduleInput = moduleInput
    }
}
