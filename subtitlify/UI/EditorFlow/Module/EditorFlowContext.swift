//
//  EditorFlowContext.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public enum EditorFlowContext {
    case new
    case demo(isBuffered: Bool)
    case project(_ project: Project)
}
