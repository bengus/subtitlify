//
//  ProjectsFlowModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum ProjectsFlowModuleAction {
    // Actions that will be available outside the module should be declared here
    case createProject
}

public protocol ProjectsFlowModuleInput: AnyObject {
    var onAction: ((ProjectsFlowModuleAction) -> Void)? { get set }
    func start(navigationController: UINavigationController)
}
