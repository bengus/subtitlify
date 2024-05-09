//
//  AboutModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

public enum AboutModuleAction {
    // Actions that will be available outside the module should be declared here
    case openDemo(isBuffered: Bool)
}

public protocol AboutModuleInput: AnyObject {
    var onAction: ((AboutModuleAction) -> Void)? { get set }
}
