//
//  PermissionsModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum PermissionsModuleAction {
    // Actions that will be available outside the module should be declared here
    case close
    case allGranted
}

public protocol PermissionsModuleInput: AnyObject {
    var onAction: ((PermissionsModuleAction) -> Void)? { get set }
}
