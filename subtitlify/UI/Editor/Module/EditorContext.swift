//
//  EditorContext.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public enum EditorContext {
    case demo(isBuffered: Bool)
    case project(_ project: Project)
}
