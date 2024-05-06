//
//  EditorFlowModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum EditorFlowModuleAction {
    // Actions that will be available outside the module should be declared here
    case close
}

public protocol EditorFlowModuleInput: AnyObject {
    var onAction: ((EditorFlowModuleAction) -> Void)? { get set }
    func start(navigationController: UINavigationController)
}
