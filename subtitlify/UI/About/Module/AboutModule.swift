//
//  AboutModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

public struct AboutModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: AboutModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: AboutModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
