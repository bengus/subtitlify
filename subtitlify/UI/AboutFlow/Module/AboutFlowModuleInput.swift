//
//  AboutFlowModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

public enum AboutFlowModuleAction {
    // Actions that will be available outside the module should be declared here
}

public protocol AboutFlowModuleInput: AnyObject {
    var onAction: ((AboutFlowModuleAction) -> Void)? { get set }
    func start(navigationController: UINavigationController)
}
