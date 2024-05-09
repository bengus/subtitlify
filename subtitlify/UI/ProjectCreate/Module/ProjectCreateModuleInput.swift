//
//  ProjectCreateModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum ProjectCreateModuleAction {
    // Actions that will be available outside the module should be declared here
    case selectVideo
    case projectCreated(_ project: Project)
    case close
}

public protocol ProjectCreateModuleInput: AnyObject {
    var onAction: ((ProjectCreateModuleAction) -> Void)? { get set }
    func setVideo(_ video: Video)
}
