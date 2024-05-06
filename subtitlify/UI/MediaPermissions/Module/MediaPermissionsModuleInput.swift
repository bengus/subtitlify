//
//  MediaPermissionsModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum MediaPermissionsModuleAction {
    // Actions that will be available outside the module should be declared here
}

public protocol MediaPermissionsModuleInput: AnyObject {
    var onAction: ((MediaPermissionsModuleAction) -> Void)? { get set }
}
