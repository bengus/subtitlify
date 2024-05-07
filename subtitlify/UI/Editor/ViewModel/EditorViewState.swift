//
//  EditorViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

struct EditorViewState: Equatable {
    enum State {
        case permissionRequired
        case selecting
        case editing
    }
    
    let isLoading: Bool
    let state: State
    let captioning: String?
    
    static func empty() -> Self {
        return EditorViewState(
            isLoading: false,
            state: .selecting,
            captioning: nil
        )
    }
}
