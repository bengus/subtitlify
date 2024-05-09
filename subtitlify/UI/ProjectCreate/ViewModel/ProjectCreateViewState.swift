//
//  ProjectCreateViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import AVFoundation

struct ProjectCreateViewState: Equatable {
    let isLoading: Bool
    
    static func empty() -> Self {
        return ProjectCreateViewState(
            isLoading: false
        )
    }
}
