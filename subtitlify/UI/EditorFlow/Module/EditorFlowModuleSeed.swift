//
//  EditorFlowModuleSeed.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public struct EditorFlowModuleSeed {
    // Parameters required to build an instance of the module should be declared here
    // for example: objectId or things like that
    public let context: EditorFlowContext
    
    public init(context: EditorFlowContext) {
        self.context = context
    }
}
