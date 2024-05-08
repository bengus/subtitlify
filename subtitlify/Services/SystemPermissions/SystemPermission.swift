//
//  SystemPermission.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public enum SystemPermission {
    case photoLibrary
    case speechRecognizer
}

public struct SystemPermissionRequest {
    public enum State {
        /// First request
        case primaryRequest
        /// Second request - in Settings app
        case secondaryRequest
        /// Request is impossible
        case denied
    }
    
    public let permission: SystemPermission
    public let state: State
    
    public init(
        permission: SystemPermission,
        state: SystemPermissionRequest.State
    ) {
        self.permission = permission
        self.state = state
    }
}
