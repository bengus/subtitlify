//
//  CaptioningDecorator.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation
import Speech

// How many segments we display in captioning at the moment
private let captioningWindowLength = 12

public final class CaptioningDecorator {
    private var currentCaptioningIndex: Array.Index?
    private var currentCaptioningRange: Range<Array.Index>?
    private var transcription: SFTranscription?
    private(set) var captioningMode: CaptioningMode = .highlighted
    private lazy var regularAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: Design.Colors.lightText,
        NSAttributedString.Key.font: Design.Fonts.semibold(ofSize: 18),
    ]
    private lazy var highlightedAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: Design.Colors.accent,
        NSAttributedString.Key.font: Design.Fonts.bold(ofSize: 18),
    ]
    private var isTailWindowMode = false
    
    
    // MARK: - Init
    init() { }
    
    
    // MARK: - Decoration
    func reset() {
        self.currentCaptioningIndex = nil
        self.currentCaptioningRange = nil
    }
    
    func setTranscription(_ transcription: SFTranscription?) {
        self.transcription = transcription
    }
    
    func setIsTailWindowMode(_ value: Bool) {
        self.isTailWindowMode = value
    }
    
    func setCaptioningMode(_ mode: CaptioningMode) {
        self.captioningMode = mode
    }
    
    func getCaptioningAttributedText() -> NSAttributedString? {
        if currentCaptioningIndex == nil && currentCaptioningRange == nil {
            return nil
        }
        
        let attributedText = NSMutableAttributedString()
        if let transcription {
            let segments = transcription.segments
            switch captioningMode {
            case .currentWord:
                if
                    let index = currentCaptioningIndex,
                    index < segments.count
                {
                    attributedText.append(NSAttributedString(
                        string: segments[index].substring,
                        attributes: regularAttributes
                    ))
                }
            case .regular:
                if let range = currentCaptioningRange {
                    // All segments the same text style
                    let captioningString = segments[range]
                        .map { $0.substring }
                        .joined(separator: " ")
                    attributedText.append(NSAttributedString(
                        string: captioningString,
                        attributes: regularAttributes
                    ))
                }
                
            case .highlighted:
                if
                    let highlightedIndex = currentCaptioningIndex,
                    let range = currentCaptioningRange,
                    range.contains(highlightedIndex)
                {
                    for index in range {
                        let segment = segments[index]
                        if index == highlightedIndex {
                            attributedText.append(NSAttributedString(
                                string: segment.substring,
                                attributes: highlightedAttributes
                            ))
                        } else {
                            attributedText.append(NSAttributedString(
                                string: segment.substring,
                                attributes: regularAttributes
                            ))
                        }
                        // add space only when not is last index
                        if index < segments.count - 1 {
                            attributedText.append(NSAttributedString(
                                string: " ",
                                attributes: regularAttributes
                            ))
                        }
                    }
                }
            }
        }
        
        return attributedText
    }
    
    func moveCaptioningWindow(currentTime: TimeInterval?) {
        if isTailWindowMode {
            // In buffered mode we have no time codes from SFSpeech, because of that our window is just the tail
            if let transcription {
                let segments = transcription.segments
                self.currentCaptioningIndex = segments.index(segments.endIndex, offsetBy: -1, limitedBy: segments.startIndex) ?? segments.startIndex
                self.currentCaptioningRange = transcription.getTailSegmentsRange(limit: captioningWindowLength)
            }
        } else {
            if
                let currentTime,
                let transcription
            {
                // current index could be nil, in case of silence (no speech that time)
                // TODO: Binary search could be better for performance and alg complexity. Skip it because of demo
                self.currentCaptioningIndex = transcription.segments.firstIndex(where: {
                    currentTime <= ($0.timestamp + $0.duration)
                })
                
                if currentCaptioningRange == nil {
                    // Mostly for the first time, when playback was not configured
                    self.currentCaptioningRange = transcription.getSegmentsRange(
                        for: currentTime,
                        limit: captioningWindowLength
                    )
                }
                
                if let currentIndex = self.currentCaptioningIndex {
                    // check if current word contains only if we have current word
                    if
                        let currentCaptioningRange,
                        !currentCaptioningRange.contains(currentIndex)
                    {
                        // if current highlighted word is already outside of visible range, move forward
                        self.currentCaptioningRange = transcription.getSegmentsRange(
                            for: currentTime,
                            limit: captioningWindowLength
                        )
                    }
                }
            }
        }
        
//#if DEBUG
//        print("--- moveCaptioningWindow ---")
//        if let currentCaptioningRange {
//            print("currentCaptioningRange: [\(currentCaptioningRange.lowerBound)..<\(currentCaptioningRange.upperBound)]")
//        }
//        if let currentCaptioningIndex {
//            print("currentCaptioningIndex: \(currentCaptioningIndex)")
//        }
//        print("currentTime: \(currentTime ?? .nan)")
//#endif
    }
}

private extension SFTranscription {
    func getSegmentsRange(for currentTime: TimeInterval, limit: Int) -> Range<Array.Index> {
        // Looking for an index according on timestampt and duration
        // TODO: Binary search could be better for performance and alg complexity. Skip it because of demo
        let startIndex = segments.firstIndex(where: {
            currentTime <= $0.timestamp + $0.duration
        }) ?? segments.startIndex
        let endIndex = segments.index(startIndex, offsetBy: captioningWindowLength, limitedBy: segments.endIndex) ?? segments.endIndex
        return startIndex..<endIndex
    }
    
    func getTailSegmentsRange(limit: Int) -> Range<Array.Index> {
        let endIndex = segments.endIndex
        let startIndex = segments.index(endIndex, offsetBy: -captioningWindowLength, limitedBy: segments.startIndex) ?? segments.startIndex
        return startIndex..<endIndex
    }
}
