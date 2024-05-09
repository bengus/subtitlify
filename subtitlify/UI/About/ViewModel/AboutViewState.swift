//
//  AboutViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

struct AboutViewState: Equatable {
    let demos: [DemoItem]
    let isLoading: Bool
    
    static func empty() -> Self {
        return AboutViewState(
            demos: [],
            isLoading: false
        )
    }
}

extension AboutViewState {
    enum DemoType {
        case buffered
        case nonBuffered
    }
    
    struct DemoItem: Equatable {
        let titleText: String
        let subtitleText: String
        let image: UIImage?
        let demoType: DemoType
        
        init(
            video: Video,
            titleText: String,
            subtitleText: String,
            demoType: DemoType
        ) {
            self.titleText = titleText
            self.subtitleText = subtitleText
            self.image = MediaUtils.previewImageFromVideo(url: video.url)
            self.demoType = demoType
        }
    }
}
