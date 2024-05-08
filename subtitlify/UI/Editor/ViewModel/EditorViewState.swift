//
//  EditorViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import AVFoundation

struct EditorViewState: Equatable {
    enum State {
        case permissionRequired
        case selecting
        case editing
    }
    
    enum CaptioningMode {
        case currentWord
        case regular
        case highlighted
    }
    
    enum TimeControlStatus {
        case paused
        case playing
        case unknown
    }
    
    let isLoading: Bool
    let state: State
    let captioningAttributedText: NSAttributedString?
    let captioningMode: CaptioningMode
    let timeControlStatus: TimeControlStatus
    
    static func empty() -> Self {
        return EditorViewState(
            isLoading: false,
            state: .selecting,
            captioningAttributedText: nil,
            captioningMode: .highlighted,
            timeControlStatus: .unknown
        )
    }
}

extension EditorViewState.CaptioningMode {
    static func fromDecoratorCaptioningMode(_ mode: CaptioningDecorator.CaptioningMode) -> Self {
        switch mode {
        case .currentWord:
            return .currentWord
        case .regular:
            return .regular
        case .highlighted:
            return .highlighted
        }
    }
}

extension EditorViewState.TimeControlStatus {
    static func fromAVPlayerTimeControlStatus(_ status: AVPlayer.TimeControlStatus?) -> Self {
        guard let status else {
            return .unknown
        }
        
        switch status {
        case .paused:
            return .paused
        case .playing:
            return.playing
        default:
            return .unknown
        }
    }
}
