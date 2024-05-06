//
//  HomeContainerModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct HomeContainerModule {
    public let containerViewController: UIViewController & DisposeBag
    public let moduleInput: HomeContainerModuleInput
    
    public init(
        containerViewController: UIViewController & DisposeBag,
        moduleInput: HomeContainerModuleInput
    ) {
        self.containerViewController = containerViewController
        self.moduleInput = moduleInput
    }
}
