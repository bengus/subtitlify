//
//  EditorModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct EditorModule {
    public let viewController: UIViewController & DisposeBag
    public let moduleInput: EditorModuleInput
    
    public init(
        viewController: UIViewController & DisposeBag,
        moduleInput: EditorModuleInput
    ) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
