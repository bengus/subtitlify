//
//  EditorViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

struct EditorViewState: Equatable {
    let isLoading: Bool
    
    static func empty() -> Self {
        return EditorViewState(isLoading: false)
    }
}
