//
//  ProjectListModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum ProjectListModuleAction {
    // Actions that will be available outside the module should be declared here
    case createProject
    case openProject(_ project: Project)
}

public protocol ProjectListModuleInput: AnyObject {
    var onAction: ((ProjectListModuleAction) -> Void)? { get set }
}
