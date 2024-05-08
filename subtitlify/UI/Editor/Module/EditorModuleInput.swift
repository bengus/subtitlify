//
//  EditorModuleInput.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum EditorModuleAction {
    // Actions that will be available outside the module should be declared here
    case selectVideo
    case close
}

public protocol EditorModuleInput: AnyObject {
    var onAction: ((EditorModuleAction) -> Void)? { get set }
}
