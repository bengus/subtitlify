//
//  EditorViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import AVFoundation

struct EditorViewState: Equatable {
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
    let captioningAttributedText: NSAttributedString?
    let captioningMode: CaptioningMode
    let timeControlStatus: TimeControlStatus
    let subtitlesPosition: CGPoint?
    
    static func empty() -> Self {
        return EditorViewState(
            isLoading: false,
            captioningAttributedText: nil,
            captioningMode: .highlighted,
            timeControlStatus: .unknown,
            subtitlesPosition: nil
        )
    }
}

extension EditorViewState.CaptioningMode {
    static func fromDecoratorCaptioningMode(_ mode: CaptioningMode) -> Self {
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
